//
//  MockedDocumentRepository.swift
//  DeviceFinderIOSTests
//
//  Created by KaitoKitaya on 2024/02/26.
//

import FirebaseFirestore
import Foundation

@testable import DeviceFinderIOS

let mockedDevice = Device(
  position: GeoPoint(latitude: 0.0, longitude: 0.0),
  device_id: "",
  device_password: "")

final class MockedDocumentRepository: DocumentRepository {

  func getDocument(completion: (() -> Void)?) async throws -> Device? {
    return mockedDevice
  }

  func getAllDocuments(completion: (() -> Void)?) async throws -> [Device] {
    return [mockedDevice]
  }

  func setDocument(device: Device, completion: (() -> Void)?) async throws {}

  func updateDocument(device_id: String, fields: [AnyHashable: Any], completion: (() -> Void)?)
    async throws
  {}

  func deleteDocument(device_id: String, completion: (() -> Void)?) async throws {}
}
