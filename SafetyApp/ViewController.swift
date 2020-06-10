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
        
 // commented because no longer needs this code since it only plots one annotation
         // Show one police station annotation on map
        let police = PoliceStation(
          title: "Toronto Police Service - 52 Division",
          locationName: "255 Dundas St W",
          coordinate: CLLocationCoordinate2D(latitude: 43.654420, longitude: -79.389385))
        mapView.addAnnotation(police)

        loadInitialData()
        mapView.addAnnotations(policeStations)


    }
    
    // array to hold the police station objects
    private var policeStations: [PoliceStation] = []

    private func loadInitialData() {
      //  Read the geoJSON file into a data object
      guard
        let fileName = Bundle.main.url(forResource: "Police_Divisions", withExtension: "geojson"),
        let policeData = try? Data(contentsOf: fileName)
        else {
          return
      }

      do {
        // Obtain an array of GeoJSON objects using MKGeoJSONDecoder and compact map
        let features = try MKGeoJSONDecoder()
          .decode(policeData)
          .compactMap { $0 as? MKGeoJSONFeature }
        // MKGeoJSONFeature objects into PoliceStation objects using the failable initializer and compact map
        let validLocations = features.compactMap(PoliceStation.init)
        // Append the
        policeStations.append(contentsOf: validLocations)
      } catch {
        // If there is an error, print it
        print("Unexpected error: \(error).")
      }
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
    //
    func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      calloutAccessoryControlTapped control: UIControl
    ) {
      guard let police = view.annotation as? PoliceStation else {
        return
      }

      let launchOptions = [
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
      ]
      police.mapItem?.openInMaps(launchOptions: launchOptions)
    }

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






