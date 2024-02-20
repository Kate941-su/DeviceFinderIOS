//
//  RegisterPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct RegisterPage: View {
    
  let deviceId: UUID = UUID()
  @State var password: String = ""
  let uuid: UUID = UUID()
  let registerPageInteractor: RegisterPageInteractor = RegisterPageInteractor()
  
    var body: some View {
      NavigationStack {
        VStack(alignment: .leading) {
          Text("Device ID")
            .padding()
            .bold()
          Text(Util.getDeviceUUID() ?? "Error(nil)")
            .padding()
          
          //TODO: Debug Only
          Text("[Debug] Custom UUID For Debug")
            .padding()
            .bold()          
          Text(uuid.uuidString)
            .padding()
          //TODO: End Debug Only
          
          Text("Device Password")
            .padding()
            .bold()
          TextField("Enter Device Password", text: $password)
            .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 18, trailing: 18))
          HStack {
            Spacer()
            TextButton(
              text: "Register",
              textColor: Color.white,
              backGroundColor: Color.blue
            )
            .onTapGesture {
              Task {
                try await registerPageInteractor.onTapRegisterButton()
              }
            }
            TextButton(
              text: "Debugsub",
              textColor: Color.white,
              backGroundColor: Color.red
            )
            Spacer()
          }
          Spacer()
        }
        .navigationTitle("Register device")
      }
    }
}

#Preview {
    RegisterPage()
}
