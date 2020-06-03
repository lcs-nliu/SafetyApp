//
//  D11.swift
//  SafetyApp
//
//  Created by Liu, Bojun on 2020-06-03.
//  Copyright © 2020 Liu, Nicole. All rights reserved.
//

import Foundation
import MapKit

class D11: NSObject, MKAnnotation {
  let address: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D

  init(
    address: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.address = address
    self.locationName = locationName
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
