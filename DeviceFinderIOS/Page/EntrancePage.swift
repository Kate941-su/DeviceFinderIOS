//
//  EntrancePage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI


// TODO: Update NavigationStack With Path
// https://qiita.com/yoshi-eng/items/91666637cd7cdd8edf88

struct EntrancePage: View {
  @EnvironmentObject var launchStateObject: LaunchStateObject
  @State var path = NavigationPath()
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        Spacer()
        NavigationLink(
          destination: FindPage(),
          label: {
            TextButton(
              text: "Find",
              textColor: Color.white,
              backGroundColor: Color.blue)
          }
        )
        Spacer()
        Divider()
        Spacer()
        NavigationLink(
          destination: RegisterPage(),
          label: {
            if (launchStateObject.state == .notRegisterd) {
              TextButton(
                text: "Register",
                textColor: Color.white,
                backGroundColor: Color.green)
            } else {
              TextButton(
                text: "Delete",
                textColor: Color.white,
                backGroundColor: Color.red)
            }
          }
        )
        Spacer()
      }
    }
  }
}

#Preview{
  EntrancePage()
}
