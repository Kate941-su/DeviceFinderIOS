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

struct RegisterPage: View {

  let debugUuid: UUID = UUID()
  let deviceUuid: String? = Util.getDeviceUUID()
  let registerPageInteractor: RegisterPageInteractor = RegisterPageInteractor()

  @State var password: String = "aaaaaaaa"
  @State var tokens: Set<AnyCancellable> = []
  @State var geoPoint: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
  @State var isShowAlert: Bool = false
  @StateObject var geoLocationService = GeoLocationService.shared

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
                isShowAlert = true
              } else {
                guard self.deviceUuid != nil else {
                  assert(false, "Missing Get UUID")
                  return
                }
                let device = Device(
                  position: geoPoint,
                  device_id: Util.getDeviceUUID()!,
                  device_password: password)
                do {
                  try await registerPageInteractor.onTapRegisterButton(device: device)
                } catch {
                  // TODO: Error Handling
                  print("\(error)")
                }
              }
            }
          }
          TextButton(
            text: "Debug",
            textColor: Color.white,
            backGroundColor: Color.red
          )
          .onTapGesture {
            Task {
              if password.count < MIN_PASSWORD_LENGTH {
                isShowAlert = true
              } else {
                guard deviceUuid != nil else {
                  assert(false, "Missing Get UUID")
                  return
                }
                let device = Device(
                  position: geoPoint,
                  device_id: debugUuid.uuidString,
                  device_password: password)
                do {
                  try await registerPageInteractor.onTapRegisterButton(device: device)
                } catch {
                  // TODO: Error Handling
                  print("\(error)")
                }
              }
            }
          }
          Spacer()
        }
        .alert(
          "Password Alert", isPresented: $isShowAlert,
          actions: {
            Button("OK") {
              isShowAlert = false
            }
          },
          message: {
            Text("You have to set passowrd more than \(MIN_PASSWORD_LENGTH) words.")
          }
        )
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
