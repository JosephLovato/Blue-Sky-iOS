//
//  FileManager.swift
//  bluesky
//
//  Created by Joey Lovato on 12/19/18.
//  Copyright © 2018 Blue Sky. All rights reserved.
//

import Foundation

public extension FileManager {
    static var documentDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

public struct userData: Codable, Equatable {
    let companyName: String
    let requestedByName: String
    let requestedByEmail: String
    let ownerName: String
    let ownerEmail: String
    
    public init(
        companyName: String,
        requestedByName: String,
        requestedByEmail: String,
        ownerName: String,
        ownerEmail: String
        ) {
        self.companyName = companyName
        self.requestedByName = requestedByName
        self.requestedByEmail = requestedByEmail
        self.ownerName = ownerName
        self.ownerEmail = ownerEmail
    }
}

