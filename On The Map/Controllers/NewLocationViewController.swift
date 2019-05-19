//
//  NewLocationViewController.swift
//  On The Map
//
//  Created by Sameer Almutairi on 18/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class NewLocationViewController: UIViewController {

    var locationMapSegueID = "DisplayMap"
    var coordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func cancelAddNewLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        let url = URL(string: websiteTextField.text!)
        guard url != nil else {
            // add alert
            print("Invalid URL")
            return
        }
        getLocationCoordinate(address: locationTextField.text!) { (coordinate, error) in
            guard let coordinate = coordinate else {
                // add alert
                print("Invalid Location")
                return
            }
            self.coordinate = coordinate
            self.performSegue(withIdentifier: self.locationMapSegueID, sender: self)
        }
    }
    
    func getLocationCoordinate(address : String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
//                print(placemarks)
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    print(location.coordinate)
                    completion(location.coordinate, nil)
                    return
                }
            }
            completion(kCLLocationCoordinate2DInvalid, error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? LocationMapViewController else {
            print("cannot cast to ViewController")
            return
        }
        destinationViewController.coordinate = self.coordinate
        destinationViewController.mediaURL = self.websiteTextField.text
        destinationViewController.mapString = self.locationTextField.text
        
        print("Start destinationViewController")
        print(destinationViewController)
        print("End destinationViewController")
    }
}

// need to add keyboard handler

extension NewLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
