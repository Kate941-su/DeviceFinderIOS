//
//  DocumentRepository.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import Foundation
import FirebaseFirestore

protocol DocumentRepository {
  func getDocument() async throws -> Device?
  func getAllDocuments() async throws -> [Device]
  func setDocument(data: Any) async throws
}

// TODO: Make repository protocol
class DocumentRepositoryImpl: ObservableObject, DocumentRepository {
  func getDocument() async throws -> Device? {
    let db = Firestore.firestore()
    let ref = db.collection("Device").document("dummy1")
    return try await ref.getDocument().data(as: Device.self)
  }
  
  func getAllDocuments() async throws -> [Device] {
    let db = Firestore.firestore()
    let ref = db.collection("Device")
    return try await ref.getDocuments().documents.compactMap{(try? $0.data(as: Device.self))}
  }
  
  func setDocument(data: Any) async throws {
    let db = Firestore.firestore()
    let device = Device(
      position: GeoPoint(latitude: 0.0, longitude: 0.0),
      device_id: "dummy",
      device_password: "dummy")
    try db.collection("Device").document("dummy123").setData(from: device)
  }
}
