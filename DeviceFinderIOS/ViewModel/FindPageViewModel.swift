//
//  FindPageViewModel.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/24.
//

import Foundation

class FindPageViewModel: ObservableObject {

  let documentRepositoryImpl = DocumentRepositoryImpl()

  func findDevice(device_id: String, device_password: String) async -> Device? {
    do {
      let deviceDocuments = try await documentRepositoryImpl.getAllDocuments()
      let device = deviceDocuments.first(where: {
        $0.device_id == device_id && $0.device_password == device_password
      })
      return device
    } catch {
      // TODO: Error Handling
      print(error)
      return nil
    }
  }

}
