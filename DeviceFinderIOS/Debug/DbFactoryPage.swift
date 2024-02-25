//
//  DbFactoryPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/25.
//

import FirebaseFirestore
import SwiftUI

struct DbFactoryPage: View {

  let documentRepository = DocumentRepositoryImpl()

  var body: some View {
    Button("Create Dummy Devices") {
      Task {
        for i in 0...9 {
          let dummyGeoPoint = GeoPoint(
            latitude: Double.random(in: -90.0..<90.0), longitude: Double.random(in: -180..<180))
          let dummyDevice = Device.setDummydevice(
            geoPoint: dummyGeoPoint, device_id: String(i), device_password: "aaaaaaaa")
          try documentRepository.setDocument(device: dummyDevice, completion: nil)
        }
      }
    }
  }
}

#Preview{
  DbFactoryPage()
}
