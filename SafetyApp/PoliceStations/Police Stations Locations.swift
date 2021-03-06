//
//  D11.swift
//  SafetyApp
//
//  Created by Liu, Bojun on 2020-06-03.
//  Copyright © 2020 Liu, Nicole. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class PoliceStation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    init?(feature: MKGeoJSONFeature) {
        // Creates a MKPointAnnotation using MapKit's geometry property
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
            else {
                return nil
        }

        // set the police station properties we need
        title = properties["AGENCY"] as? String
        locationName = properties["ADDRESS"] as? String
        coordinate = point.coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
        var mapItem: MKMapItem? {
          guard let location = locationName else {
            return nil
          }
    
          let addressDict = [CNPostalAddressStreetKey: location]
          let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict)
          let mapItem = MKMapItem(placemark: placemark)
          mapItem.name = title
          return mapItem
        }
    
}

