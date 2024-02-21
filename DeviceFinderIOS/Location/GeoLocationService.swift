//
//  DeviceGeoLocationService.swift
//  ShareHappy
//
//  Created by KaitoKitaya on 2024/02/08.
//

import Combine
import CoreLocation
import FirebaseFirestore
import Foundation

let POLE_RADIUS: Double = 6356752.314245
let EQUATOR_RADIUS: Double = 6378137.0

class GeoLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
  // Notify event
  var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()

  var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()

  override private init() {
    super.init()
  }

  static let shared = GeoLocationService()

  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.delegate = self
    return manager
  }()

  func requestLocationUpdates() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      locationManager.startUpdatingLocation()
    default:
      deniedLocationAccessPublisher.send()
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("\(manager.authorizationStatus)")
    switch manager.authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.startUpdatingLocation()
    default:
      manager.stopUpdatingLocation()
      deniedLocationAccessPublisher.send()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    coordinatesPublisher.send(location.coordinate)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    coordinatesPublisher.send(completion: .failure(error))
  }

  func getDistance(point1: GeoPoint, point2: GeoPoint) -> Double {
    /// https://www.gis-py.com/entry/py-latlon2distance
    let radianPoint1 = point1.convertToRadian()
    let radianPoint2 = point2.convertToRadian()
    let pointDifference = radianPoint2 - radianPoint1
    let latAverage = (radianPoint1.latitude + radianPoint2.latitude) / 2
    let e2 = (pow(EQUATOR_RADIUS, 2) - pow(POLE_RADIUS, 2)) / pow(EQUATOR_RADIUS, 2)
    let w = sqrt(1 - e2 * pow(sin(latAverage), 2))
    let m = EQUATOR_RADIUS * (1 - e2) / pow(w, 3)
    let n = EQUATOR_RADIUS / w
    let distance = sqrt(
      pow(m * pointDifference.latitude, 2) + pow(n * pointDifference.longitude * cos(latAverage), 2)
    )
    print(distance)
    return distance
  }
}

extension GeoPoint {

  static func + (left: GeoPoint, right: GeoPoint) -> GeoPoint {
    return GeoPoint(
      latitude: left.latitude + right.latitude, longitude: left.longitude + right.longitude)
  }

  static func - (left: GeoPoint, right: GeoPoint) -> GeoPoint {
    return GeoPoint(
      latitude: left.latitude - right.latitude, longitude: left.longitude - right.longitude)
  }

  func degreeToRadian(degree: Double) -> Double {
    return degree * .pi / 180
  }

  func radianToDegree(radian: Double) -> Double {
    return radian * 180 / .pi
  }

  func convertToRadian() -> GeoPoint {
    return GeoPoint(
      latitude: degreeToRadian(degree: self.latitude),
      longitude: degreeToRadian(degree: self.longitude)
    )
  }

  func convertToDegree() -> GeoPoint {
    return GeoPoint(
      latitude: radianToDegree(radian: self.latitude),
      longitude: radianToDegree(radian: self.longitude)
    )
  }
}
