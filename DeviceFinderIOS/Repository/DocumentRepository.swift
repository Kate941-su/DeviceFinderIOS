//
//  DocumentRepository.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import FirebaseFirestore
import Foundation

protocol DocumentRepository {
  func getDocument(completion: (() -> Void)?) async throws -> Device?
  func getAllDocuments(completion: (() -> Void)?) async throws -> [Device]
  func setDocument(device: Device, completion: (() -> Void)?) async throws
  func updateDocument(device_id: String, fields: [AnyHashable: Any], completion: (() -> Void)?)
    async throws
  func deleteDocument(device_id: String, completion: (() -> Void)?) async throws
}

// TODO: Make repository protocol
class DocumentRepositoryImpl: ObservableObject, DocumentRepository {
  func getDocument(completion: (() -> Void)?) async throws -> Device? {
    let db = Firestore.firestore()
    let ref = db.collection("Device").document("dummy1")
    let document = try await ref.getDocument().data(as: Device.self)
    if let completion {
      completion()
    }
    return document
  }

  func getAllDocuments(completion: (() -> Void)?) async throws -> [Device] {
    let db = Firestore.firestore()
    let ref = db.collection("Device")
    let documents = try await ref.getDocuments().documents.compactMap {
      (try? $0.data(as: Device.self))
    }
    if let completion {
      completion()
    }
    return documents
  }

  func setDocument(device: Device, completion: (() -> Void)?) throws {
    let db = Firestore.firestore()
    let device = device
    try db.collection("Device").document(device.device_id).setData(from: device)
    if let completion {
      completion()
    }
  }

  func deleteDocument(device_id: String, completion: (() -> Void)?) async throws {
    let db = Firestore.firestore()
    try await db.collection("Device").document(device_id).delete()
    if let completion {
      completion()
    }
  }

  func updateDocument(device_id: String, fields: [AnyHashable: Any], completion: (() -> Void)?)
    async throws
  {
    let db = Firestore.firestore()
    try await db.collection("Device").document(device_id).updateData(fields)
  }

}
