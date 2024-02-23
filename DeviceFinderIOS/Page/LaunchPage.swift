//
//  LaunchPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct LaunchPage: View {
  let documentRepository = DocumentRepositoryImpl()
  @EnvironmentObject var launchStateObject: LaunchStateObject
  
  var body: some View {
    if launchStateObject.state == .fetching {
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
              let deviceList = try await documentRepository.getAllDocuments()
              if (deviceList.map{ it in it.device_id }.contains(uuid)){
                launchStateObject.state = .registerd
              } else {
                launchStateObject.state = .notRegisterd
              }
              print("Has Registered ?: \(launchStateObject.state)")
            } catch {
              print(error)
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

