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

struct RegisterScreen: View {

  let debugUuid: UUID = UUID()
  let deviceUuid: String? = Util.getDeviceUUID()

  @EnvironmentObject var deviceRegisterStateNotifier: DeviceRegisterStateNotifier
  @StateObject var registerViewModel: RegisterViewModel

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
      TextField("Enter Device Password", text: $registerViewModel.password)
        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 18, bottom: 18, trailing: 18))
      if registerViewModel.password.count < MIN_PASSWORD_LENGTH {
        Text("You have to set passowrd more than \(MIN_PASSWORD_LENGTH) words.")
          .foregroundStyle(Color.red)
          .padding()
      }
      // TODO: Debug Only
      Text("Now your Location")
        .fontWeight(.bold)
        .padding()

      // Debug Only
      Text(
        "latitude: \(registerViewModel.geoPoint.latitude), longitude: \(registerViewModel.geoPoint.longitude)"
      )
      .padding()
      HStack {
        Spacer()
        TextButton(
          text: "Register",
          textColor: Color.white,
          backGroundColor: Color.green
        )
        .opacity(registerViewModel.isInitialized ? 1.0 : 0.5)
        .onTapGesture {
          Task {
            deviceRegisterStateNotifier.state = await registerViewModel.onTapRegisterButton()
          }
        }
        Spacer()
      }
      Spacer()
        .alert(
          registerViewModel.alertType.title,
          isPresented: $registerViewModel.isShowAlert,
          actions: {
            Button("OK") {
              registerViewModel.isShowAlert = false
            }
          }
        ) {
          Text(registerViewModel.alertType.description)
        }
    }
    .onAppear {
      registerViewModel.initialize()
    }
    .environmentObject(deviceRegisterStateNotifier)
  }

}

#Preview{
  RegisterScreen(registerViewModel: RegisterViewModel(documentRepository: DocumentRepositoryImpl()))
}
