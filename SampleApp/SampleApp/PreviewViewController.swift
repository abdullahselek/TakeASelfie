//
//  PreviewViewController.swift
//  SampleApp
//
//  Created by Abdullah Selek on 04.08.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import UIKit
import Photos

typealias ImageCallback = ((UIImage?) -> Void)

class PreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLastPhoto(resizeTo: imageView.frame.size) { image in
            guard let image = image else {
                return
            }
            self.imageView.image = image
        }
    }

    func getPhotoLibraryAuthorizationStatus(status: PHAuthorizationStatus, completionBlock: @escaping ((Bool) -> Void)) {
        switch status {
        case .authorized:
            completionBlock(true)
        case .denied:
            completionBlock(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    completionBlock(true)
                } else {
                    print("PhotoLibrary request authorization failed!")
                    completionBlock(false)
                }
            }
        case .restricted:
            completionBlock(false)
        }
    }

    func fetchLastPhoto(resizeTo size: CGSize, imageCallback: @escaping ImageCallback) {
        getPhotoLibraryAuthorizationStatus(status: PHPhotoLibrary.authorizationStatus()) { granted in
            if granted {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 1
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                if let asset = fetchResult.firstObject {
                    let manager = PHImageManager.default()
                    // let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    manager.requestImage(for: asset,
                                         targetSize: size,
                                         contentMode: .aspectFit,
                                         options: nil,
                                         resultHandler: { image, info in
                                            DispatchQueue.main.async {
                                                imageCallback(image)
                                            }
                    })
                } else {
                    DispatchQueue.main.async {
                        imageCallback(nil)
                    }
                }
            } else {
                print("No access to photo library!")
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
