//
//  CallViewController.swift
//  bluesky
//
//  Created by David Kopala on 8/16/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func blueSkyTapped(_ sender: Any) {
        if let url = Constants.CallBlueSkyURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func joelTapped(_ sender: Any) {
        if let url = Constants.CallJoelURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func billTapped(_ sender: Any) {
        if let url = Constants.CallBillURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
