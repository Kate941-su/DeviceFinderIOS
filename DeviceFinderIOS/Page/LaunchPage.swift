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
  @State var state: DeviceRegisterState = .pending

  var body: some View {
    if state == .pending {
      VStack(alignment: .center) {
        Image(.splash)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
      }.onAppear {
        Task {
          state = launchStateViewModel.deviceRegisterState
          // TODO: Firebase Fetch Error Handling
          do {
            let uuid = Util.getDeviceUUID() ?? ""
            let deviceList = try await documentRepository.getAllDocuments(completion: nil)
            if deviceList.map({ it in it.device_id }).contains(uuid) {
              launchStateViewModel.deviceRegisterState = .registered
              state = launchStateViewModel.deviceRegisterState
            } else {
              launchStateViewModel.deviceRegisterState = .notRegisterd
              state = launchStateViewModel.deviceRegisterState
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
