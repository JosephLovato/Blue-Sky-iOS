//
//  UserData.swift
//  bluesky
//
//  Created by Joey Lovato on 12/19/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import Foundation

import UIKit
import os.log


class UserData: NSObject, NSCoding {
    
    //MARK: Properties
    
    var companyName: String
    var firstLastName: String
    var companyEmail: String
    var agencyEmail: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("UserData")
    
    //MARK: Types
    
    struct PropertyKey {
        static let companyName = "companyName"
        static let firstLastName = "firstLastName"
        static let companyEmail = "companyEmail"
        static let agencyEmail = "agencyEmail"
    }
    
    //MARK: Initialization
    
    init?(companyName: String, firstLastName: String, companyEmail: String, agencyEmail: String) {
        
        // The name must not be empty
        guard !companyName.isEmpty else {
            return nil
        }
        guard !firstLastName.isEmpty else {
            return nil
        }
        guard !companyEmail.isEmpty else {
            return nil
        }
        guard !agencyEmail.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.companyName = companyName
        self.firstLastName = firstLastName
        self.companyEmail = companyEmail
        self.agencyEmail = agencyEmail
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(companyName, forKey: PropertyKey.companyName)
        aCoder.encode(firstLastName, forKey: PropertyKey.firstLastName)
        aCoder.encode(companyEmail, forKey: PropertyKey.companyEmail)
        aCoder.encode(agencyEmail, forKey: PropertyKey.agencyEmail)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let companyName = aDecoder.decodeObject(forKey: PropertyKey.companyName) as! String
        let firstLastName = aDecoder.decodeObject(forKey: PropertyKey.firstLastName) as! String
        let companyEmail = aDecoder.decodeObject(forKey: PropertyKey.companyEmail) as! String
        let agencyEmail = aDecoder.decodeObject(forKey: PropertyKey.agencyEmail) as! String



        // Must call designated initializer.
        self.init(companyName: companyName, firstLastName: firstLastName, companyEmail: companyEmail, agencyEmail: agencyEmail)
        
    }
}
