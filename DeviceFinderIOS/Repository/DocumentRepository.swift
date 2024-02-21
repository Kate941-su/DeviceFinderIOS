//
//  DocumentRepository.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import FirebaseFirestore
import Foundation

protocol DocumentRepository {
  func getDocument() async throws -> Device?
  func getAllDocuments() async throws -> [Device]
  func setDocument(device: Device) async throws
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
    return try await ref.getDocuments().documents.compactMap { (try? $0.data(as: Device.self)) }
  }

  func setDocument(device: Device) async throws {
    let db = Firestore.firestore()
    let device = device
    try db.collection("Device").document(device.device_id).setData(from: device)
  }
}
