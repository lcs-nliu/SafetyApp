//
//  ViewController.swift
//  SafetyApp
//
//  Created by Liu, Bojun on 2020-05-25.
//  Copyright © 2020 Liu, Nicole. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    // outlet that connects map to controller
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set initial location to Toronto
        let initialLocation = CLLocation(latitude: 43.669914, longitude: -79.39031)
        mapView.centerToLocation(initialLocation)
        
        // contrains the camera (how much user can zoom in or zoom out) used 45km by 20 km around the length and width of Toronto
        let torontoCenter = CLLocation(latitude: 43.669914, longitude: -79.39031)
        let region = MKCoordinateRegion(
          center: torontoCenter.coordinate,
          latitudinalMeters: 45000,
          longitudinalMeters: 20000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)

        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)

    }
    
    
}
// sets rectangular region to control zoom level (currently set to 5km)
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 5000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}



