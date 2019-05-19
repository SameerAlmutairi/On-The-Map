//
//  MapViewController.swift
//  On The Map
//
//  Created by Sameer Almutairi on 17/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import MapKit
import CoreLocation
import UIKit

class MapViewController: UIViewController{
    
//    var students = [StudentLocation]()
    var students: [StudentLocation] = []
    var annotations: [MKPointAnnotation] = []
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadingAllStudentsLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadingAllStudentsLocations()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.deleteSession { (data, error) in
            if data != nil {
                UserDefaults.standard.set("", forKey: "accountKey")
                self.dismiss(animated: true, completion: nil)
            }
            else {
                // add alert
                print("Logout Faild")
            }
        }
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        loadingAllStudentsLocations()
    }

    
    func loadingAllStudentsLocations() {
        
        ParseClient.getAllStudentLocation { (response, error) in
            if let resposen = response {
                self.students = resposen
                Students.students = response!
                self.createAnnotaions()
            }
            else {
                
            }
        }
    }
    
    func createAnnotaions(){
        mapView.removeAnnotations(annotations)
        for location in self.students {
            let latitude = CLLocationDegrees(location.latitude ?? 0)
            let longitude = CLLocationDegrees(location.longitude ?? 0)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = coordinate
            newAnnotation.title = "\(firstName ?? "") \(lastName ?? "")"
            newAnnotation.subtitle = mediaURL
            
            annotations.append(newAnnotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

