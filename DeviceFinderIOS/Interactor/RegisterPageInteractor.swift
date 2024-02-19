//
//  RegisterPageInteractor.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import Foundation
import FirebaseFirestore

// TODO: Make repository protocol
class RegisterPageInteractor: ObservableObject {
  
  func onTapRegisterButton(device_id: String, device_password: String) async {
//    do {
//      guard let device = try await getDocument() else {
//        print("\(#function): Device is nil")
//        return
//      }
//      print(device)
//    } catch {
//      print(error)
//    }
    do {
      let documents = try await getDocuments()
      print(documents)
    } catch {
      print(error)
    }
  }
  
  func getDocument() async throws -> Device? {
    let db = Firestore.firestore()
    let ref = db.collection("Device").document("dummy1")
    return try await ref.getDocument().data(as: Device.self)
  }
  
  func getDocuments() async throws -> [Device] {
    let db = Firestore.firestore()
    let ref = db.collection("Device")
    return try await ref.getDocuments().documents.compactMap{(try? $0.data(as: Device.self))}
  }
  
  func setDocument() async throws {
    let db = Firestore.firestore()
    let device = Device(position: GeoPoint(latitude: 0.0, longitude: 0.0), device_id: "dummy", device_password: "dummy")
    try db.collection("Device").document("dummy123").setData(from: device)
  }
}
