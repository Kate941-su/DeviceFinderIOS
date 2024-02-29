//
//  LaunchPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct SplashScreen: View {
  let documentRepository: DocumentRepository
  @EnvironmentObject private var deviceRegisterStateNotifier: DeviceRegisterStateNotifier

  init(documentRepositry: DocumentRepository) {
    self.documentRepository = documentRepositry
  }

  var body: some View {
    if deviceRegisterStateNotifier.state == .pending {
      VStack(alignment: .center) {
        Image(.splash)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
      }
      .environmentObject(deviceRegisterStateNotifier)
      .onAppear {
        Task {
          // TODO: Firebase Fetch Error Handling
          do {
            let uuid = Util.getDeviceUUID() ?? ""
            let deviceList = try await documentRepository.getAllDocuments(completion: nil)
            if deviceList.map({ it in it.device_id }).contains(uuid) {
              deviceRegisterStateNotifier.state = .registered
            } else {
              deviceRegisterStateNotifier.state = .notRegisterd
            }
          } catch {
            print("[Launch Page]: \(error)")
          }
        }
      }
    } else {
      EntranceScreen(entranceViewModel: EntranceViewModel(documentRepository: documentRepository))
    }
  }
}

#Preview{
  SplashScreen(documentRepositry: DocumentRepositoryImpl())
}
