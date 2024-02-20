//
//  MarkerPlace.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import Foundation
import CoreLocation
import FirebaseFirestore


struct MarkerPlace: Identifiable {
  let id: UUID
  let location: CLLocationCoordinate2D
  init(id: UUID = UUID(), geoPoint: GeoPoint) {
    self.id = id
    self.location = CLLocationCoordinate2D(
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude
    )
  }
}
