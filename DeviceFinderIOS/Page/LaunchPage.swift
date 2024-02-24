//
//  LaunchPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct LaunchPage: View {
  let documentRepository = DocumentRepositoryImpl()
  @EnvironmentObject var launchStateViewModel: LaunchPageViewModel

  var body: some View {
    if launchStateViewModel.deviceRegisterState == .pending {
      VStack(alignment: .center) {
        Image(.splash)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
      }.onAppear {
        Task {
          // TODO: Firebase Fetch Error Handling
          do {
            let uuid = Util.getDeviceUUID() ?? ""
            let deviceList = try await documentRepository.getAllDocuments(completion: nil)
            if deviceList.map({ it in it.device_id }).contains(uuid) {
              launchStateViewModel.deviceRegisterState = .registered
            } else {
              launchStateViewModel.deviceRegisterState = .notRegisterd
            }
            print("Has Registered ?: \(launchStateViewModel.deviceRegisterState)")
          } catch {
            print("[Launch Page]: \(error)")
          }
        }
      }
    } else {
      EntrancePage()
    }
  }
}

#Preview{
  LaunchPage()
}
