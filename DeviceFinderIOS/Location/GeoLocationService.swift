//
//  DeviceGeoLocationService.swift
//  ShareHappy
//
//  Created by KaitoKitaya on 2024/02/08.
//

import Combine
import CoreLocation
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
    
  func getDistance(point1: Coordinates, point2: Coordinates) -> Double {
    /// https://www.gis-py.com/entry/py-latlon2distance
    let radianPoint1 = point1.convertToRadian()
    let radianPoint2 = point2.convertToRadian()
    let pointDifference = radianPoint2 - radianPoint1
    let latAverage = (radianPoint1.latitude + radianPoint2.latitude) / 2
    let e2 = (pow(EQUATOR_RADIUS, 2) - pow(POLE_RADIUS, 2)) / pow(EQUATOR_RADIUS, 2)
    let w = sqrt(1 - e2 * pow(sin(latAverage), 2))
    let m = EQUATOR_RADIUS * (1 - e2) / pow(w, 3)
    let n = EQUATOR_RADIUS / w
    let distance = sqrt(pow(m * pointDifference.latitude, 2) + pow(n * pointDifference.longitude * cos(latAverage), 2))
    print(distance)
    return distance
  }
}

struct Coordinates {
  let longitude: Double
  let latitude: Double
  init(latitude: Double, logitude: Double) {
    self.latitude = latitude
    self.longitude = logitude
  }
  
  static func + (left: Coordinates, right: Coordinates) -> Coordinates {
    return Coordinates(latitude: left.latitude + right.latitude, logitude: left.longitude + right.longitude)
  }

  static func - (left: Coordinates, right: Coordinates) -> Coordinates {
    return Coordinates(latitude: left.latitude - right.latitude, logitude: left.longitude - right.longitude)
  }
  
  func degreeToRadian(degree: Double) -> Double {
    return degree * .pi / 180
  }
  
  func radianToDegree(radian: Double) -> Double {
    return radian * 180 / .pi
  }
  
  func convertToRadian() -> Coordinates {
    return Coordinates(
      latitude: degreeToRadian(degree: self.longitude),
      logitude: degreeToRadian(degree: self.latitude)
    )
  }

  func convertToDegree() -> Coordinates {
    return Coordinates(
      latitude: radianToDegree(radian: self.longitude),
      logitude: radianToDegree(radian: self.latitude)
    )
  }
  
}
