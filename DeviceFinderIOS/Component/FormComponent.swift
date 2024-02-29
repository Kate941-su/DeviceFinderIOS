//
//  FormComponent.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/26.
//

import FirebaseFirestore
import SwiftUI

struct FormComponent: View {

  let documentRepository: DocumentRepository

  @EnvironmentObject var deviceRegisterStateNotifier: DeviceRegisterStateNotifier

  @StateObject var geoLocationService = GeoLocationService.shared

  let deviceId: String?
  @State private var password: String = ""
  @State private var geoPoint: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
  @State private var isShowAlert: Bool = false
  @State fileprivate var alertType: AlertType = .none

  init(documentRepository: DocumentRepository, deviceId: String?) {
    self.documentRepository = documentRepository
    self.deviceId = deviceId
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Device ID")
        .padding()
        .bold()
      Text(deviceId ?? "")
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
      HStack {
        Spacer()
        TextButton(
          text: "Register",
          textColor: Color.white,
          backGroundColor: Color.green
        )
        .onTapGesture {
          Task {
            if password.count < MIN_PASSWORD_LENGTH {
              alertType = .invalidPassword
            } else {
              guard self.deviceId != nil else {
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
    }
  }
}

#Preview{
  FormComponent(documentRepository: DocumentRepositoryImpl(), deviceId: "")
}
