//
//  RegisterPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import Combine
import FirebaseFirestore
import SwiftUI

let MIN_PASSWORD_LENGTH = 8

private enum AlertType {
  case valid
  case invalidPassword
  case invalidByFirebase
  case failedToGetUuid
  case none
  
  var title: String {
    get {
      switch self {
      case .valid:
        return "Register Succeeded"
      case .invalidPassword:
        return "Invalid Password"
      case .invalidByFirebase:
        return "Failed to Register Database"
      case .failedToGetUuid:
        return "Faild to Get Device ID"
      case .none:
        return "Debug None"
      }
    }
  }
  
  var description: String {
    get {
      switch self {
      case .valid:
        return "Your device has registered normally."
      case .invalidPassword:
        return "You have to set password at least \(MIN_PASSWORD_LENGTH) characters."
      case .invalidByFirebase:
        return "Your device has not registered due to something wrong with network."
      case .failedToGetUuid:
        return "Failed to get your device ID."
      case .none:
        return "Debug only screen."
      }
    }
  }
  
}

struct RegisterPage: View {

  let debugUuid: UUID = UUID()
  let deviceUuid: String? = Util.getDeviceUUID()
  let registerPageViewModel: RegisterPageViewModel = RegisterPageViewModel()

  @EnvironmentObject var launchPageViewModel: LaunchPageViewModel

  @StateObject var geoLocationService = GeoLocationService.shared

  @State private var password: String = "aaaaaaaa"
  @State private var tokens: Set<AnyCancellable> = []
  @State private var geoPoint: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
  @State private var isShowAlert: Bool = false
  @State fileprivate var alertType: AlertType = .none

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        Text("Device ID")
          .padding()
          .bold()
        Text(deviceUuid ?? "Error(nil)")
          .padding()

        //TODO: Debug Only
        Text("[Debug] Custom UUID For Debug")
          .padding()
          .bold()
        Text(debugUuid.uuidString)
          .padding()
        //TODO: End Debug Only

        Text("Device Password")
          .padding()
          .bold()
        TextField("Enter Device Password", text: $password)
          .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
          .padding(EdgeInsets(top: 0, leading: 18, bottom: 18, trailing: 18))
        if password.count < MIN_PASSWORD_LENGTH {
          Text("You have to set passowrd more than \(MIN_PASSWORD_LENGTH) words.")
            .foregroundStyle(Color.red)
            .padding()
        }
        HStack {
          Spacer()
          TextButton(
            text: "Register",
            textColor: Color.white,
            backGroundColor: Color.blue
          )
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
                  try await registerPageViewModel.onTapRegisterButton(device: device)
                  launchPageViewModel.deviceRegisterState = .registered
                  alertType = .valid
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
        .alert(
          alertType.title,
          isPresented: $isShowAlert,
          actions: {
            Button("OK") {
              isShowAlert = false
            }
          }) {
            Text(alertType.description)
          }
        Spacer()
      }
      .navigationTitle("Register device")
      .onAppear {
        observeCoordinateUpdates()
        observeLocationAccessDenied()
        geoLocationService.requestLocationUpdates()
      }
    }
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
}

#Preview{
  RegisterPage()
}
