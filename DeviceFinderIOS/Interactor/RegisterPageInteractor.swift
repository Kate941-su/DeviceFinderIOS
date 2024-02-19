//
//  RegisterPageInteractor.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/19.
//

import Foundation
import FirebaseFirestore

// TODO: Make repository protocol
class RegisterPageInteractor {
  let documentRepository: DocumentRepository = DocumentRepositoryImpl()
  func onTapRegisterButton() async throws {
    let result = try await documentRepository.getAllDocuments()
    print(result)
  }
}
