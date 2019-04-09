//
//  SelfieViewController.swift
//  TakeASelfie
//
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
                                          options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    private let ovalOverlayView = OvalOverlayView()
    open weak var delegate: SelfieViewDelegate?

    public init(withDelegate delegate: SelfieViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("TakeASelfie: init(coder:) has not been implemented")
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
                print("TakeASelfie: Cannot construct capture device input")
            }
        } else {
            print("TakeASelfie: Cannot get capture device")
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
        @unknown default:
            fatalError()
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
            print("TakeASelfie: Face inside the overlay!")
            captureSession.stopRunning()
            UIImageWriteToSavedPhotosAlbum(faceUIImage,
                                           self,
                                           #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        // swiftlint:disable line_length
        guard let (faceCIImage, faceUIImage) = SelfieHelper.createFaceImages(sampleBuffer: sampleBuffer) as? (CIImage, UIImage) else {
            print("TakeASelfie: creating face images returns nil")
            return
        }
        let options = [CIDetectorImageOrientation: SelfieHelper.orientation(orientation: UIDevice.current.orientation),
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

extension SelfieViewController: AlertControllerProtocol { }
