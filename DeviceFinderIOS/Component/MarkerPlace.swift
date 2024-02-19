//
//  MarkerPlace.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import Foundation
import CoreLocation


struct MarkerPlace: Identifiable {
  let id: UUID
  let location: CLLocationCoordinate2D
  init(id: UUID = UUID(), coordinates: Coordinates) {
    self.id = id
    self.location = CLLocationCoordinate2D(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude
    )
  }
}
