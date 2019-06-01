//
//  SettingsViewController.swift
//  bluesky
//
//  Created by Joey Lovato on 12/17/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var requestedByNameTextField: UITextField!
    @IBOutlet weak var requestedByEmailTextField: UITextField!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var ownerEmailTextField: UITextField!
    let dataURL = FileManager.documentDirectoryURL.appendingPathComponent("data")

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let jsonDecoder = JSONDecoder()
            let savedJSONData = try Data(contentsOf: dataURL)
            let dataNew = try jsonDecoder.decode(userData.self, from: savedJSONData)
            companyNameTextField.text = dataNew.companyName
            requestedByNameTextField.text = dataNew.requestedByName
            requestedByEmailTextField.text = dataNew.requestedByEmail
            ownerNameTextField.text = dataNew.ownerName
            ownerEmailTextField.text = dataNew.ownerEmail
        } catch {
            print("error")
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let companyName = companyNameTextField.text
        let requestedByName = requestedByNameTextField.text
        let requestedByEmail = requestedByEmailTextField.text
        let ownerName = ownerNameTextField.text
        let ownerEmail = ownerEmailTextField.text
        let test = userData(companyName: companyName ?? "", requestedByName: requestedByName ?? "", requestedByEmail: requestedByEmail ?? "", ownerName: ownerName ?? "", ownerEmail: ownerEmail ?? "")
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try jsonEncoder.encode(test)
            try jsonData.write(to: dataURL)
        } catch {
            print("error2")
        }
    }
}
