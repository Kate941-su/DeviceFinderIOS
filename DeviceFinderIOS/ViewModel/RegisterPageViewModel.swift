//
//  RegisterPageInteractor.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import FirebaseFirestore
import Foundation

// TODO: Make repository protocol
class RegisterPageInteractor {
  let documentRepository: DocumentRepository = DocumentRepositoryImpl()
  func onTapRegisterButton(device: Device) async throws {
    try await documentRepository.setDocument(device: device)
  }
}
