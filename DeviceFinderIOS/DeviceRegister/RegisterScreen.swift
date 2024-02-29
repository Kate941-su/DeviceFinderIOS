//
//  RegisterScreen.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import Combine
import FirebaseFirestore
import MapKit
import SwiftUI

enum AlertType {
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

struct RegisterScreen: View {

  let debugUuid: UUID = UUID()
  let deviceUuid: String? = Util.getDeviceUUID()
  let documentRepository: DocumentRepository

  @EnvironmentObject var deviceRegisterStateNotifier: DeviceRegisterStateNotifier

  @StateObject var geoLocationService = GeoLocationService.shared

  @State private var password: String = ""
  @State private var tokens: Set<AnyCancellable> = []
  @State private var geoPoint: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
  @State private var isShowAlert: Bool = false
  @State fileprivate var alertType: AlertType = .none
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 35.0, longitude: 135.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )
  @State private var isInitialized = true
  @State private var options: MKMapSnapshotter.Options = .init()

  init(documentRepository: DocumentRepository) {
    self.documentRepository = documentRepository
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Device ID")
        .padding()
        .bold()
      Text(deviceUuid ?? "")
        .padding()
      Text("Device Password")
        .padding()
        .bold()
      // TODO: Secure Field
      TextField("Enter Device Password", text: $password)
        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 18, bottom: 18, trailing: 18))
      if password.count < MIN_PASSWORD_LENGTH {
        Text("You have to set passowrd more than \(MIN_PASSWORD_LENGTH) words.")
          .foregroundStyle(Color.red)
          .padding()
      }
      // TODO: Debug Only
      Text("Now your Location")
        .fontWeight(.bold)
        .padding()

      // Debug Only
      Text("latitude: \(geoPoint.latitude), longitude: \(geoPoint.longitude)")
        .padding()
      HStack {
        Spacer()
        TextButton(
          text: "Register",
          textColor: Color.white,
          backGroundColor: Color.green
        )
        .opacity(isInitialized ? 1.0 : 0.5)
        .onTapGesture {
          Task {
            if password.count < MIN_PASSWORD_LENGTH {
              alertType = .invalidPassword
            } else {
              guard self.deviceUuid != nil else {
                alertType = .failedToGetUuid
                return
              }
              let device = Device(
                position: geoPoint,
                device_id: Util.getDeviceUUID()!,
                device_password: password)
              do {
                try await documentRepository.setDocument(device: device) {
                  deviceRegisterStateNotifier.state = .registered
                  alertType = .valid
                }
              } catch {
                print("\(error)")
                alertType = .invalidByFirebase
              }
            }
            isShowAlert = true
          }
        }
        Spacer()
      }
      Spacer()
      .alert(
        alertType.title,
        isPresented: $isShowAlert,
        actions: {
          Button("OK") {
            isShowAlert = false
          }
        }
      ) {
        Text(alertType.description)
      }
    }
    .onAppear {
      observeCoordinateUpdates()
      observeLocationAccessDenied()
      geoLocationService.requestLocationUpdates()
    }
    .environmentObject(deviceRegisterStateNotifier)
  }

  // TODO: Getting rid of deprecating of FindPage
  private func observeCoordinateUpdates() {
    geoLocationService.coordinatesPublisher.receive(on: DispatchQueue.main)
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
    geoLocationService.deniedLocationAccessPublisher.receive(on: DispatchQueue.main)
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

#Preview{
  RegisterScreen(documentRepository: DocumentRepositoryImpl())
}
