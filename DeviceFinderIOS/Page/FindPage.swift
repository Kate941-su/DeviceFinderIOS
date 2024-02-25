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
    case .noDevice:
      return "No device was found."
    case .wrongPassword:
      return "Device was registerd. But you tried a wrong password."
    case .none:
      return "This alert only can see debug mode only."
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
  
  let initialRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )

  @State private var deviceId: String = ""
  @State private var password: String = ""

  @StateObject private var findPageViewModel = FindPageViewModel()
  @State private var foundDeviceGeoPoint: GeoPoint?
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
    latitudinalMeters: MAP_BASE_SCALE,
    longitudinalMeters: MAP_BASE_SCALE
  )
  @State var isShowAlert: Bool = false
  @State var mapFetchStatus: MapFetchStatus = .notYet
  @State var alertType: FindPageAlertType = .none
  
  @FocusState private var isDeviceIdFieldFocused: Bool
  @FocusState private var isDevicePasswordFieldFocused: Bool

  var body: some View {
    NavigationStack {
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
          ButtonComponent(
            text: "Find",
            textColor: Color.white,
            backGroundColor: Color.blue,
            disabled: isDeviceIdFieldFocused || isDevicePasswordFieldFocused
          ) {
            Task {
              mapFetchStatus = .loading
              // TODO: Implementing Wrong Password
              if let findDevice: Device = await findPageViewModel.findDevice(
                device_id: deviceId,
                device_password: password)
              {
                foundDeviceGeoPoint = GeoPoint(
                  latitude: findDevice.position.latitude,
                  longitude: findDevice.position.longitude)
                region = MKCoordinateRegion(
                  center: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(foundDeviceGeoPoint!.latitude),
                    longitude: CLLocationDegrees(foundDeviceGeoPoint!.longitude)),
                  latitudinalMeters: MAP_BASE_SCALE,
                  longitudinalMeters: MAP_BASE_SCALE
                )
                print($region)
                mapFetchStatus = .ready
              } else {
                alertType = .noDevice
                isShowAlert = true
                mapFetchStatus = .notYet
              }
            }
          }
          Spacer()
        }.padding()
        switch mapFetchStatus {
        case .ready, .notYet:
          // TODO: Debug Only
          Text("latitude: \(foundDeviceGeoPoint!.latitude)")
            .padding()
          Text("longitude: \(foundDeviceGeoPoint!.longitude)")
            .padding()
          // TODO: End Debug Only
          let place = [MarkerPlace(geoPoint: foundDeviceGeoPoint!)]

          // TODO: Use bounds, interactionModes: scope if OS version >= iOS 17
          Map(
            coordinateRegion: $region,
            interactionModes: .all,
            annotationItems: place
          ) { place in
            MapMarker(
              coordinate: place.location,
              tint: Color.orange)
          }
        case .loading:
          HStack(alignment: .center) {
            Spacer()
            ProgressView()
              .progressViewStyle(.circular)
              .scaleEffect(2.0)
            Spacer()
          }
        }
        Spacer()
      }.navigationTitle("Find")
    }.alert(
      "Error", isPresented: $isShowAlert,
      actions: {
        Button("OK") {
          isShowAlert = false
        }
      }
    ) {
      Text("No device was founded")
    }
  }
}

#Preview{
  FindPage()
}
