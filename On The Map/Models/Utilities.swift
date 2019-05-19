//
//  Utilities.swift
//  On The Map
//
//  Created by Sameer Almutairi on 20/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation
import UIKit

enum Utilities {
    static func displayAlertMessage(viewController: UIViewController,title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
            viewController.present(alert,animated: true, completion: nil)
        }
    }
}
