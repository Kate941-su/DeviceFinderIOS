//
//  RegisterViewModel.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/29.
//

import Combine
import FirebaseFirestore
import Foundation
import MapKit
import SwiftUI

enum RegisterScreenAlertType {
  case valid
  case invalidPassword
  case invalidByFirebase
  case failedToGetUuid
  case none

  var title: String {
    switch self {
    case .valid: "Register Succeeded"
    case .invalidPassword: "Invalid Password"
    case .invalidByFirebase: "Failed to Register Database"
    case .failedToGetUuid: "Faild to Get Device ID"
    case .none: "Debug None"
    }
  }

  var description: String {
    switch self {
    case .valid: "Success to register your device.\n Please remember DeviceID and password you set."
    case .invalidPassword: "You have to set password at least \(MIN_PASSWORD_LENGTH) characters."
    case .invalidByFirebase: "Your device has not registered due to something wrong with network."
    case .failedToGetUuid: "Failed to get your device ID."
    case .none: "Debug only screen."
    }
  }

}

class RegisterViewModel: ObservableObject {

  let documentRepository: DocumentRepository

  init(documentRepository: DocumentRepository) {
    self.documentRepository = documentRepository
  }

  @StateObject var geoLocationNotifier = GeoLocationNotifier.shared

  @Published var password: String = ""
  @Published var tokens: Set<AnyCancellable> = []
  @Published var geoPoint: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
  @Published var isShowAlert: Bool = false
  @Published var alertType: RegisterScreenAlertType = .none
  @Published var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 35.0, longitude: 135.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )
  @Published var isInitialized = true
  @Published var options: MKMapSnapshotter.Options = .init()

  func initialize() {
    self.observeCoordinateUpdates()
    self.observeLocationAccessDenied()
    geoLocationNotifier.requestLocationUpdates()
  }

  func onTapRegisterButton() async -> DeviceRegisterState {
    if password.count < MIN_PASSWORD_LENGTH {
      alertType = .invalidPassword
    } else {
      if let deviceUuid = Util.getDeviceUUID() {
        let device = Device(
          position: geoPoint,
          device_id: deviceUuid,
          device_password: password)
        do {
          try await documentRepository.setDocument(device: device) {
            print("Succeeded to Register Document \(device)")
          }
          alertType = .valid
          isShowAlert = true
        } catch {
          print("\(error)")
          alertType = .invalidByFirebase
        }
      } else {
        alertType = .failedToGetUuid
      }
    }
    isShowAlert = true
    return alertType == .valid ? .registered : .notRegisterd
  }

  // TODO: Getting rid of deprecating of FindPage
  private func observeCoordinateUpdates() {
    geoLocationNotifier.coordinatesPublisher.receive(on: DispatchQueue.main)
      .sink {
        completion in
        if case .failure(let error) = completion {
          print(error)
        }
      } receiveValue: { geoPoint in
        self.geoPoint = GeoPoint(
          latitude: geoPoint.latitude,
          longitude: geoPoint.longitude
        )
      }.store(in: &tokens)
  }

  private func observeLocationAccessDenied() {
    geoLocationNotifier.deniedLocationAccessPublisher.receive(on: DispatchQueue.main)
      .sink {
        // TODO: Lost geolocation data error handling
        print("Show some kind of alert to the user")
      }.store(in: &tokens)
  }

  //  private func observeResionUpdates() {
  //    geoLocationService.resionPublisher.first().sink(
  //      receiveCompletion: { completion in
  //        // TODO: Error Handling
  //        print(completion)
  //      },
  //      receiveValue: { value in
  //        region = value
  //        print("observed region is => \(value)")
  //        isInitialized = true
  //      }
  //    ).store(in: &tokens)
  //  }

}
