//
//  StudentLocation.swift
//  On The Map
//
//  Created by Sameer Almutairi on 17/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
//    init(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String ,objectId: String, uniqueKey: String ,updatedAt: String) {
//        self.createdAt = ""
//        self.firstName = ""
//        self.lastName  = ""
//        self.latitude  = 0.0
//        self.longitude = 0.0
//        self.mapString = ""
//        self.mediaURL  = ""
//        self.objectId  = ""
//        self.uniqueKey = ""
//        self.updatedAt = ""
//    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}



