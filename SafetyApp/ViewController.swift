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
        
     mapView.delegate = self
        
         // Show one police station annotation on map
        let police = PoliceStation(
          title: "Toronto Police Service - 11 Division",
          locationName: "2054 Davenport Rd",
          coordinate: CLLocationCoordinate2D(latitude: 43.671234, longitude: -79.460771))
        mapView.addAnnotation(police)

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

extension ViewController: MKMapViewDelegate {
  // call map view for every annotation
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
  ) -> MKAnnotationView? {
    // check if it is a police station object
    guard let annotation = annotation as? PoliceStation else {
      return nil
    }
    // displays markers at the annotations
    let identifier = "PoliceStation"
    var view: MKMarkerAnnotationView
    // reuses annotation views that are no longer visible
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // Create new view if annotation view cannot be displayed
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}






