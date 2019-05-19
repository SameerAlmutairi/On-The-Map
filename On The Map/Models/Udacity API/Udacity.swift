//
//  Udacity.swift
//  On The Map
//
//  Created by Sameer Almutairi on 17/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    let udacity: [String:String]
    
    init(username: String, password: String) {
        self.udacity = ["username": username, "password": password]
    }
}
