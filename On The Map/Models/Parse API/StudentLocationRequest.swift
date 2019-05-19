//
//  StudentLocationRequest.swift
//  On The Map
//
//  Created by Sameer Almutairi on 19/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    
    //    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    //    let objectId: String?
    let uniqueKey: String?
    //    let updatedAt: String?
    
    
    enum CodingKeys: String, CodingKey {
        //        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        //        case objectId
        case uniqueKey
        //        case updatedAt
    }
}
