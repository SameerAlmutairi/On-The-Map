//
//  LocationMapViewController.swift
//  On The Map
//
//  Created by Sameer Almutairi on 18/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var coordinate: CLLocationCoordinate2D!
    var mapString: String!
    var mediaURL: String!
    var uniqueKey = UserDefaults.standard.object(forKey: "accountKey") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        PinLocation()
        print("coordinate is \(coordinate)")
        print("mapString is \(mapString)")
        print("mediaURL is \(mediaURL)")
    }
    
    @IBAction func finishPostNewLocation(_ sender: Any) {
//         add condition for empty data
        
        let student = StudentLocationRequest(firstName: "", lastName: "", latitude: self.coordinate.latitude, longitude: self.coordinate.longitude, mapString: self.mapString, mediaURL: self.mediaURL, uniqueKey: uniqueKey)
//
        print(student)
        ParseClient.postStudnetLocation(student: student) { (response, error) in
            if error != nil {
                print(error)
            }
            
            print("+++++++ Start Student +++++++")
            print(student)
            print("+++++++ Start Student +++++++")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func PinLocation(){
        let coordinate = CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        
        // Zooming
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension LocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let urlString = view.annotation?.subtitle,
                let url = URL(string: urlString ?? ""),
                UIApplication.shared.canOpenURL(url) else {
                    print("Invalid Error")
                    return
            }
        }
    }
    
}


// need to add update
