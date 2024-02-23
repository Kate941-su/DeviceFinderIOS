//
//  EntrancePageViewModel.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/23.
//

import Foundation

class EntrancePageViewModel: ObservableObject {
  let documentRepository = DocumentRepositoryImpl()
  func onTapConfirmDelete(device_id: String) async {
    // TODO: Error Handling
    do {
      try await documentRepository.deleteDocument(device_id: device_id)
    } catch {
     print(error)
    }
  }
}
