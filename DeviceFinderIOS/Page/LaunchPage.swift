//
//  LaunchPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct LaunchPage: View {
  @State var state = LaunchStateObject().state
  var body: some View {
    if state == .fetching {
      VStack(alignment: .center) {
        Image(.splash)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()

      }.onAppear {
        Task {
          //          try await Task.sleep(for: .seconds(2))
          //          state = .login
        }
      }
    } else if state == .login {
      //      FilePickerPage()
      //      LoginPage()
    } else {
      //      AvailableUserPage(userName: "")
    }
  }
}

#Preview{
  LaunchPage()
}

class LaunchStateObject: ObservableObject {
  @Published var state: LaunchState = .fetching
}

enum LaunchState {
  case fetching
  case login
  case main
}
