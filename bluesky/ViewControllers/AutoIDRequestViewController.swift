//
//  AutoIDRequestViewController.swift
//  bluesky
//
//  Created by Joey Lovato on 12/17/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import UIKit


class AutoIDRequestViewController: UIViewController {
    
    
    @IBOutlet weak var viewInScroll: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var vimNumberTextField: UITextField!
    @IBOutlet weak var coverageSegmentedButton: UISegmentedControl!
    @IBOutlet weak var addDeleteSegmentedButton: UISegmentedControl!
    @IBOutlet weak var autoIDCardLabel: UILabel!
    @IBOutlet weak var autoIDCard: UISwitch!
    @IBOutlet weak var submitButton: UIButton!
    let dataURL = FileManager.documentDirectoryURL.appendingPathComponent("data")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont.systemFont(ofSize: 20)
        coverageSegmentedButton.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        addDeleteSegmentedButton.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    @IBAction func onButtonPush(_ sender: Any) {
        //replicate button press visual
        submitButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        sendEmail()
    }
    
    @IBAction func onButtonRelease(_ sender: Any) {
        let message = yearTextField.text!
        print(message)
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
    
    @IBAction func addIDCardToggle(_ sender: Any) {
        if addDeleteSegmentedButton.selectedSegmentIndex == 0 {
            autoIDCard.isHidden = false
            autoIDCardLabel.isHidden = false
        } else if addDeleteSegmentedButton.selectedSegmentIndex == 1 {
                autoIDCard.isHidden = true
                autoIDCardLabel.isHidden = true
        }
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
        //format segmented button strings
        var coverage = ""
        var addDel = ""
        var cardBool = true
        switch coverageSegmentedButton.selectedSegmentIndex {
        case 0:
            coverage = "  > Liability"
        case 1:
            coverage = "  > Full Coverage"
        default:
            coverage = ""
        }
        switch addDeleteSegmentedButton.selectedSegmentIndex {
        case 0:
            addDel = "  > ADD"
        case 1:
            addDel = "  > DELETE"
            cardBool = false
        default:
            addDel = ""
        }
        //format switch button
        var card = ""
        if(cardBool) {
            if(autoIDCard.isOn) {
                card = "  > Auto ID Card Needed"
            }
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
        builder.header.subject = "Auto ID Requested by \(companyName)"
        builder.htmlBody="<p>***Receipt from BlueSky Automated Email Service***</p> <p> --AUTO ID REQUEST-- </p> <p> Company: \(companyName)</p> <p>Requested by: \(requestedByName) </p> <p>Owner: \(ownerName) </p> <p>DETAILS:</p> <p> Year: \(yearTextField.text ?? "-N/A-") </p> <p> Make: \(makeTextField.text ?? "-N/A-") </p> <p> Model: \(modelTextField.text ?? "-N/A-") </p> <p> VIN Number: \(vimNumberTextField.text ?? "-N/A-") </p> <p> \(coverage) </p> <p> \(addDel) </p> <p> \(card) </p>"
        
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
    
}
