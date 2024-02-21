//
//  EntrancePage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct EntrancePage: View {
  
  @State var isPressed: Bool = true
  
  var body: some View {
    NavigationStack {
      VStack {
        Spacer()
        NavigationLink(
          destination: FindPage(),
          label: {
            TextButton(
              text: "Find",
              textColor: Color.white,
              backGroundColor: Color.blue)
            .opacity(isPressed ? 0.6 : 1.0)
            .scaleEffect(isPressed ? 1.2 : 1.0)
            
          }
        )
        Spacer()
        Divider()
        Spacer()
        NavigationLink(
          destination: RegisterPage(),
          label: {
            TextButton(
              text: "Register",
              textColor: Color.white,
              backGroundColor: Color.green)
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
