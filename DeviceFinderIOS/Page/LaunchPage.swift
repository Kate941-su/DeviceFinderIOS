//
//  LaunchPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct LaunchPage: View {
  let documentRepository = DocumentRepositoryImpl()
  @EnvironmentObject private var launchPageViewModel: LaunchPageViewModel
  
  var body: some View {
    if launchPageViewModel.deviceRegisterState == .pending {
      VStack(alignment: .center) {
        Image(.splash)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
      }
      .environmentObject(launchPageViewModel)
      .onAppear {
        Task {
          // TODO: Firebase Fetch Error Handling
          do {
            let uuid = Util.getDeviceUUID() ?? ""
            let deviceList = try await documentRepository.getAllDocuments(completion: nil)
            if deviceList.map({ it in it.device_id }).contains(uuid) {
              launchPageViewModel.deviceRegisterState = .registered
            } else {
              launchPageViewModel.deviceRegisterState = .notRegisterd
            }
            print("Has Registered ?: \(launchPageViewModel.deviceRegisterState)")
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
