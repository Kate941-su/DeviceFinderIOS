//
//  EntrancePage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct EntrancePage: View {
    var body: some View {
      NavigationStack {
        VStack {
          Spacer()
          NavigationLink(
            destination: FindPage(),
            label: {TextButton(
                      text: "Find",
                      textColor: Color.white,
                      backGroundColor: Color.blue)}
          )
          Spacer()
          Divider()
          Spacer()
          NavigationLink(
            destination: RegisterPage(),
            label: {TextButton(
                      text: "Register",
                      textColor: Color.white,
                      backGroundColor: Color.green)}
          )
          Spacer()
        }
      }
    }
}

#Preview {
    EntrancePage()
}
