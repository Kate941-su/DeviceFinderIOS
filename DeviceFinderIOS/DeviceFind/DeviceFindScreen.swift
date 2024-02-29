//
//  FindPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import Combine
import FirebaseFirestore
import MapKit
import SwiftUI

struct DeviceFindScreen: View {

  @StateObject var deviceFindViewModel: DeviceFindViewModel

  @FocusState var isDeviceIdFieldFocused: Bool
  @FocusState var isDevicePasswordFieldFocused: Bool

  var body: some View {
    VStack(alignment: .leading) {
      Text("Device ID").padding()
      TextField("Enter Device ID", text: $deviceFindViewModel.deviceId)
        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        .focused($isDeviceIdFieldFocused)
      Text("Device Password").padding()
      TextField("Enter Device Password", text: $deviceFindViewModel.password)
        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        .focused($isDevicePasswordFieldFocused)
      HStack {
        Spacer()
        NavigationLink(value: Router.foundLocationPageRoute) {
          TextButton(
            text: "Find",
            textColor: Color.white,
            backGroundColor: Color.blue
          )
        }
        Spacer()
      }.padding()
      // TODO: implement find device.
      switch deviceFindViewModel.mapFetchStatus {
      case .ready:
        Text("TODO: Navigation")
      case .loading:
        HStack(alignment: .center) {
          Spacer()
          ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2.0)
          Spacer()
        }
      case .notYet:
        Text("Please fill in the textfield.")
      }
      Spacer()
    }
    .alert(
      "Error", isPresented: $deviceFindViewModel.isShowAlert,
      actions: {
        Button("OK") {
          deviceFindViewModel.isShowAlert = false
        }
      }
    ) {
      Text("No device was founded")
    }
  }
}

#Preview{
  DeviceFindScreen(
    deviceFindViewModel: DeviceFindViewModel(documentRepository: DocumentRepositoryImpl()))
}
