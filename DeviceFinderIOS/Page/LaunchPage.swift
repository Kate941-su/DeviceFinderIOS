//
//  LaunchPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

enum DeviceRegisterState {
  case pending
  case notRegisterd
  case registered
}

class LaunchState: ObservableObject {
  @Published var state: DeviceRegisterState = .pending
}

struct LaunchPage: View {
  let documentRepository: DocumentRepository
  @EnvironmentObject private var launchState: LaunchState

  init(documentRepositry: DocumentRepository) {
    self.documentRepository = documentRepositry
  }
  
  
  var body: some View {
    if launchState.state == .pending {
      VStack(alignment: .center) {
        Image(.splash)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
      }
      .environmentObject(launchState)
      .onAppear {
        Task {
          // TODO: Firebase Fetch Error Handling
          do {
            let uuid = Util.getDeviceUUID() ?? ""
            let deviceList = try await documentRepository.getAllDocuments(completion: nil)
            if deviceList.map({ it in it.device_id }).contains(uuid) {
              launchState.state = .registered
            } else {
              launchState.state = .notRegisterd
            }
          } catch {
            print("[Launch Page]: \(error)")
          }
        }
      }
    } else {
      EntrancePage(documentrepositry: documentRepository)
    }
  }
}

#Preview{
  LaunchPage(documentRepositry: DocumentRepositoryImpl())
}
