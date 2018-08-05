//
//  SelfieViewController.swift
//  TakeASelfie
//
//  Created by Abdullah Selek on 03.08.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreImage

public protocol SelfieViewDelegate: class {
    func selfieViewControllerDismissed()
}

open class SelfieViewController: UIViewController {

    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private let faceDetector = CIDetector(ofType: CIDetectorTypeFace,
                                          context: nil,
                                          options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
    private let ovalOverlayView = OvalOverlayView()
    open weak var delegate: SelfieViewDelegate?

    public init(withDelegate delegate: SelfieViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        setupCapture(withAuthorizationStatus: authorizationStatus)
    }

    fileprivate func addCaptureDeviceInput() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                                    .builtInTelephotoCamera],
                                                                      mediaType: .video,
                                                                      position: .front)
        if let captureDevice = deviceDiscoverySession.devices.first {
            do {
                let captureInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.beginConfiguration()
                guard captureSession.canAddInput(captureInput) else {
                    return
                }
                captureSession.addInput(captureInput)
                let captureOutput = AVCaptureVideoDataOutput()
                captureOutput.alwaysDiscardsLateVideoFrames = true
                let dispatchQueue = DispatchQueue(label: "com.abdullahselek.TakeASelfieCameraSessionQueue", attributes: [])
                captureOutput.setSampleBufferDelegate(self, queue: dispatchQueue)
                guard self.captureSession.canAddOutput(captureOutput) else {
                    return
                }
                captureSession.addOutput(captureOutput)
                captureSession.sessionPreset = .photo
                captureSession.commitConfiguration()
                captureSession.startRunning()

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.frame = self.view.layer.bounds
                view.layer.addSublayer(self.videoPreviewLayer)

                view.addSubview(ovalOverlayView)
            } catch {
                print("Cannot construct capture device input")
            }
        } else {
            print("Cannot get capture device")
            let okAlertAction = UIAlertAction(title: "Ok", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            showAlertController(title: "Warning",
                                message: "Cannot get capture device",
                                actions: [okAlertAction])
        }
    }

    fileprivate func setupCapture(withAuthorizationStatus status: AVAuthorizationStatus) {
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.setupCapture(withAuthorizationStatus: granted ? .authorized : .denied)
            }
        case .restricted, .denied:
            let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            showAlertController(title: "Can not access camera",
                                message: "Please go to settings and enable camera access permission",
                                actions: [okAlertAction])
        case .authorized:
            DispatchQueue.main.async {
                self.addCaptureDeviceInput()
            }
        }
    }

    deinit {
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }
        captureSession = nil
        videoPreviewLayer = nil
    }
}

extension SelfieViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    @objc fileprivate func image(_ image: UIImage,
                                 didFinishSavingWithError error: Error?,
                                 contextInfo: UnsafeRawPointer) {
        let okAlertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.dismiss(animated: true, completion: {
                self.delegate?.selfieViewControllerDismissed()
            })
        }
        if let error = error {
            showAlertController(title: "Can't save photo",
                                message: error.localizedDescription,
                                actions: [okAlertAction])
        } else {
            showAlertController(title: "Saved",
                                message: "Your selfie successfully saved to library.",
                                actions: [okAlertAction])
        }
    }

    fileprivate func handleFaceFeatures(features: [CIFeature],
                                        faceImage: CIImage,
                                        faceUIImage: UIImage) {
        guard let features = features as? [CIFaceFeature] else {
            return
        }
        if features.isEmpty || features.count > 2 {
            return
        }
        let image = UIImage(ciImage: faceImage)
        let faceFeature = features[0]
        let bounds = faceFeature.bounds(for: image, inView: ovalOverlayView.overlayFrame.size)
        if ovalOverlayView.overlayFrame.contains(bounds) {
            print("Face inside the overlay!")
            captureSession.stopRunning()
            UIImageWriteToSavedPhotosAlbum(faceUIImage,
                                           self,
                                           #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    fileprivate func orientation(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portraitUpsideDown:
            return 8
        case .landscapeLeft:
            return 3
        case .landscapeRight:
            return 1
        case .portrait:
            return 6
        default:
            return 6
        }
    }

    fileprivate func createFaceImages(sampleBuffer: CMSampleBuffer) -> (CIImage?, UIImage?) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return (nil, nil)
        }
        let faceCIImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        // swiftlint:disable line_length
        guard let faceImage = context.createCGImage(faceCIImage, from: CGRect(x: 0,
                                                                              y: 0,
                                                                              width: CVPixelBufferGetWidth(pixelBuffer),
                                                                              height: CVPixelBufferGetHeight(pixelBuffer))) else {
                                                                                return (nil, nil)
        }
        let faceUIImage = UIImage(cgImage: faceImage,
                                  scale: 0.0,
                                  orientation: UIImageOrientation.right)
        return (faceCIImage, faceUIImage)
    }

    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        guard let (faceCIImage, faceUIImage) = createFaceImages(sampleBuffer: sampleBuffer) as? (CIImage, UIImage) else {
            print("TakeASelfie: creating face images returns nil")
            return
        }
        let options = [CIDetectorImageOrientation: orientation(orientation: UIDevice.current.orientation),
                       CIDetectorSmile: true,
                       CIDetectorEyeBlink: true] as [String: Any]
        guard let features = faceDetector?.features(in: faceCIImage, options: options) else {
            print("TakeASelfie: face features nil")
            return
        }
        DispatchQueue.main.async {
            self.handleFaceFeatures(features: features,
                                    faceImage: faceCIImage,
                                    faceUIImage: faceUIImage)
        }
    }

}
