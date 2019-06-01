//
//  CertRequestViewController.swift
//  bluesky
//
//  Created by Joey Lovato on 12/17/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import UIKit


class CertRequestViewController: UIViewController {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var recipientCompanyName: UITextField!
    @IBOutlet weak var recipientEmail: UITextField!
    @IBOutlet weak var recipientStreetAddress: UITextField!
    @IBOutlet weak var recipientCity: UITextField!
    @IBOutlet weak var recipientState: UITextField!
    @IBOutlet weak var recipientZipCode: UITextField!
    @IBOutlet weak var recipientDescription: UITextView!
    @IBOutlet weak var recipientAdditionalInsured: UISwitch!
    @IBOutlet weak var recipientWaiver: UISwitch!
    @IBOutlet weak var submitButton: UIButton!
    let dataURL = FileManager.documentDirectoryURL.appendingPathComponent("data")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    fileprivate func sendEmail() {
        //fetch setting data from device storage
        var companyName = ""
        var requestedByName = ""
        var requestedByEmail = ""
        var ownerName = ""
        var ownerEmail = ""
        do {
            let jsonDecoder = JSONDecoder()
            let savedJSONData = try Data(contentsOf: dataURL)
            let dataNew = try jsonDecoder.decode(userData.self, from: savedJSONData)
            companyName = dataNew.companyName
            requestedByName = dataNew.requestedByName
            requestedByEmail = dataNew.requestedByEmail
            ownerName = dataNew.ownerName
            ownerEmail = dataNew.ownerEmail
        } catch {
            print("data error")
        }
        //fetch bluesky email
        let blueSkyEmail = Constants.BlueSkyEmail
        //format address string
        let fullAddress = "<p>Address: \(recipientStreetAddress.text ?? "-N/A-")</p> <p> \(recipientCity.text ?? "-N/A-"), \(recipientState.text ?? "-N/A-") \(recipientZipCode.text ?? "-N/A-") </p>"
        //format switch state strings
        var addIns = ""
        var waiver = ""
        if(recipientAdditionalInsured.isOn) {
            addIns = "  > Additional Insured"
        }
        if(recipientWaiver.isOn) {
            waiver = "  > Needs Waiver"
        }
        //send email
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "blueskyappdevelopment@gmail.com"
        smtpSession.password = "Summer2018"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "", mailbox: blueSkyEmail)]
        builder.header.from = MCOAddress(displayName: "BlueSky Automated Email Service", mailbox: "blueskyappdevelopment@gmail.com")
        builder.header.cc = [MCOAddress(mailbox: requestedByEmail), MCOAddress(mailbox: ownerEmail)]
        builder.header.subject = "Cert Requested by \(companyName)"
        builder.htmlBody="<p>***Receipt from BlueSky Automated Email Service***</p> <p> --CERT REQUEST-- </p> <p> Company: \(companyName)</p> <p>Requested by: \(requestedByName) </p> <p>Owner: \(ownerName) </p> <p>DETAILS:</p> <p> Recipient Company Name: \(recipientCompanyName.text ?? "-N/A-") </p> <p> Recipient Email: \(recipientEmail.text ?? "-N/A-") </p> \(fullAddress) <p> Description: \(recipientDescription.text ?? "-N/A-") <p> \(addIns) </p> <p> \(waiver) </p>"
        
        
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
            } else {
                NSLog("Successfully sent email!")
                
            }
        }
        let alert = UIAlertController(title: "Blue Sky Email Service", message: "Your request has been sent!", preferredStyle: UIAlertControllerStyle.alert)
        let clickAction = UIAlertAction(title: "Okay", style: .default){action in
            _ = self.navigationController?.popViewController(animated: true)
            
        }
        alert.addAction(clickAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onButtonPush(_ sender: Any) {
        //replicate button press visual
        submitButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        sendEmail()
    }
    
    @IBAction func onButtonRelease(_ sender: Any) {
        submitButton.backgroundColor = #colorLiteral(red: 0.1589999944, green: 0.7070000172, blue: 0.08600000292, alpha: 1)
        
        
    }
    
    @IBAction func onButtonReleaseOutisde(_ sender: Any) {
        submitButton.backgroundColor = #colorLiteral(red: 0.1589999944, green: 0.7070000172, blue: 0.08600000292, alpha: 1)
    }
    @objc func keyBoardWillChange(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scroll.contentInset = UIEdgeInsets.zero
        } else {
            scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scroll.scrollIndicatorInsets = scroll.contentInset
        
    }
    
}
