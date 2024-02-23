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
  @EnvironmentObject var launchPageViewModel: LaunchPageViewModel
  @StateObject var entrancePageViewModel: EntrancePageViewModel = EntrancePageViewModel()
  @State var path = NavigationPath()
  @State var isShowDeleteDialog = false
  
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
        if launchPageViewModel.deviceRegisterState == .notRegisterd {
          NavigationLink(
            destination: RegisterPage(),
            label: {
                TextButton(
                  text: "Register",
                  textColor: Color.white,
                  backGroundColor: Color.green)
            }
          )
        } else {
          TextButton(
            text: "Delete",
            textColor: Color.white,
            backGroundColor: Color.red)
          .onTapGesture {
            print("Delte tapped")
              isShowDeleteDialog = true
          }
          .alert("Your device will be out of management and you will not be able to find it. Are you all right?",
                 isPresented: $isShowDeleteDialog, actions: {
            Button(action: {
              isShowDeleteDialog = false
            }, label: {
              Text("No").bold()
            })
            Button(action: {
              Task {
                // TODO: nil Handling
                try await entrancePageViewModel.documentRepository.deleteDocument(device_id: Util.getDeviceUUID() ?? "")
                isShowDeleteDialog = false
              }
            }, label: {
              Text("Yes")
            })
          })
        }
        Spacer()
      }
    }
  }
}

#Preview{
  EntrancePage()
}
