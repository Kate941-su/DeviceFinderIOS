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

// unit: meter(m)
let baseScale: CLLocationDistance = 100

enum FindPageAlertType {
  case noDevice
  case wrongPassword
  case none
  
  var title: String {
    get {
      return "Error"
    }
  }
  
  var description: String {
    get {
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
  
}

struct FindPage: View {

  // visibleForTesting
  let uuid: String = Util.getDeviceUUID() ?? ""

  @State private var deviceId: String = ""
  @State private var password: String = ""

  @StateObject private var findPageViewModel = FindPageViewModel()

  @State private var foundDeviceGeoPoint: GeoPoint?
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 35.0, longitude: 135.0),
    latitudinalMeters: baseScale,
    longitudinalMeters: baseScale
  )
  @State var isShowAlert: Bool = false
  @State var canShowMap: Bool = false
  @State var alertType: FindPageAlertType = .none

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        Text("Device ID").padding()
        TextField("Enter Device ID", text: $deviceId)
          .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
          .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        Text("Device Password").padding()
        TextField("Enter Device Password", text: $password)
          .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
          .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        HStack {
          Spacer()
          TextButton(
            text: "Find",
            textColor: Color.white,
            backGroundColor: Color.blue
          )
          .onTapGesture {
            print("On Tapped")
            Task {
              // TODO: Implementing Wrong Password
              if let findDevice: Device = await findPageViewModel.findDevice(
                device_id: deviceId,
                device_password: password)
              {
                foundDeviceGeoPoint = GeoPoint(latitude: findDevice.position.latitude,
                                               longitude: findDevice.position.longitude)
                region = MKCoordinateRegion(
                  center: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(foundDeviceGeoPoint!.latitude),
                    longitude: CLLocationDegrees(foundDeviceGeoPoint!.longitude)),
                  latitudinalMeters: baseScale,
                  longitudinalMeters: baseScale
                )
                print($region)
                canShowMap = true
              } else {
                alertType = .noDevice
                isShowAlert = true
              }
            }
          }
          // Debug: Start
          TextButton(
            text: "Debug Find",
            textColor: Color.white,
            backGroundColor: Color.red
          )
          .onTapGesture {
            Task {
              if let findDevice: Device = await findPageViewModel.findDevice(
                device_id: Util.getDeviceUUID()!,
                device_password: "aaaaaaaa")
              {
                foundDeviceGeoPoint = GeoPoint(latitude: findDevice.position.latitude,
                                               longitude: findDevice.position.longitude)
                region = MKCoordinateRegion(
                  center: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(foundDeviceGeoPoint!.latitude),
                    longitude: CLLocationDegrees(foundDeviceGeoPoint!.longitude)),
                  latitudinalMeters: baseScale,
                  longitudinalMeters: baseScale
                )
                print($region)
                canShowMap = true
              } else {
                // TODO: Implementing Wrong Password
                alertType = .noDevice
                isShowAlert = true
              }
            }
          }
          // Debug: End
          Spacer()
        }.padding()
        if canShowMap {
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
