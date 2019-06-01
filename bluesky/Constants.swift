//
//  Constants.swift
//  bluesky
//
//  Created by David Kopala on 8/16/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import Foundation

class Constants {
    
    static let BlueSkyPhoneNumber: String = "3036455477"
    static let JoelPhoneNumber: String = "3038425456"
    static let BillPhoneNumber: String = "7209888802"
    
    static let CallBlueSkyURL: URL? = URL(string: "tel://\(Constants.BlueSkyPhoneNumber)")
    static let CallJoelURL: URL? = URL(string: "tel://\(Constants.JoelPhoneNumber)")
    static let CallBillURL: URL? = URL(string: "tel://\(Constants.BillPhoneNumber)")
    
    static let BlueSkyEmail: String = "jlovato@mymail.mines.edu"
    
    
}
