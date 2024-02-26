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

struct FindPage: View {

  // visibleForTesting
  let uuid: String = Util.getDeviceUUID() ?? ""

  let documentRepository: DocumentRepository

  let initialRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )

  @State private var deviceId: String = ""
  @State private var password: String = ""
  @State private var foundDeviceGeoPoint: GeoPoint?
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )
  @State var isShowAlert: Bool = false
  @State var mapFetchStatus: MapFetchStatus = .notYet
  @State var alertType: FindPageAlertType = .none
  @State var path = NavigationPath()

  @FocusState private var isDeviceIdFieldFocused: Bool
  @FocusState private var isDevicePasswordFieldFocused: Bool
  
  init(documentRepository: DocumentRepository) {
    self.documentRepository = documentRepository
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Device ID").padding()
      TextField("Enter Device ID", text: $deviceId)
        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        .focused($isDeviceIdFieldFocused)
      Text("Device Password").padding()
      TextField("Enter Device Password", text: $password)
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
      switch mapFetchStatus {
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
      "Error", isPresented: $isShowAlert,
      actions: {
        Button("OK") {
          isShowAlert = false
        }
      }
    ) {
      Text("No device was founded")
    }
    .navigationTitle("Find")
    .navigationDestination(
      for: Router.self,
      destination: { it in
        if true {
          it.Destination(documentRepository: documentRepository)
        }
      }
    )
  }

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

#Preview{
  FindPage(documentRepository: DocumentRepositoryImpl())
}
