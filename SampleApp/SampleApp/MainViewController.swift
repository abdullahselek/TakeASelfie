//
//  MainViewController.swift
//  SampleApp
//
//  Created by Abdullah Selek on 04.08.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import UIKit
import TakeASelfie

class MainViewController: UIViewController {

    @IBAction func launchSDKButtonTapped(_ sender: Any) {
        let selfieViewController = SelfieViewController(withDelegate: self)
        present(selfieViewController, animated: true, completion: nil)
    }

}

extension MainViewController: SelfieViewDelegate {

    func selfieViewControllerDismissed() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let previewViewController = mainStoryboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        present(previewViewController, animated: true, completion: nil)
    }

}
