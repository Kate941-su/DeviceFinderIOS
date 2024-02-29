//
//  DeviceFindViewModel.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/29.
//

import FirebaseFirestore
import Foundation
import MapKit
import SwiftUI

enum FindPageAlertType {
  case noDevice
  case wrongPassword
  case none

  var title: String {
    return "Error"
  }

  var description: String {
    switch self {
    case .noDevice: "No device was found."
    case .wrongPassword: "Device was registerd. But you tried a wrong password."
    case .none: "This alert only can see debug mode only."
    }
  }
}

enum MapFetchStatus {
  case notYet
  case loading
  case ready
}

class DeviceFindViewModel: ObservableObject {

  let documentRepository: DocumentRepository

  init(documentRepository: DocumentRepository) {
    self.documentRepository = documentRepository
  }

  @Published var deviceId: String = ""
  @Published var password: String = ""
  @Published var foundDeviceGeoPoint: GeoPoint?
  @Published var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )
  @Published var isShowAlert: Bool = false
  @Published var mapFetchStatus: MapFetchStatus = .notYet
  @Published var alertType: FindPageAlertType = .none

  func findDevice(device_id: String, device_password: String) async -> Device? {
    do {
      let deviceDocuments = try await documentRepository.getAllDocuments(completion: nil)
      let device = deviceDocuments.first(where: {
        $0.device_id == device_id && $0.device_password == device_password
      })
      return device
    } catch {
      // TODO: Error Handling
      print(error)
      return nil
    }
  }

}
