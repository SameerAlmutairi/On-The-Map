//
//  UdacityPostSession.swift
//  On The Map
//
//  Created by Sameer Almutairi on 17/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation

struct UdacityPostSession: Codable {
    let session: UserSession?
    let account: UserAccount?
    let status: Int?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
        case status
        case error
    }
}
