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

  @State private var path = NavigationPath()
  @State private var isShowDeleteDialog = false
  @State private var isFetching = false

  var body: some View {
    NavigationStack(path: $path) {
      ZStack{
        if isFetching {
          ProgressView()
        }
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
              backGroundColor: Color.red
            )
            .onTapGesture {
              print("Delete tapped")
              isShowDeleteDialog = true
            }
            .alert(
              "Confirmation",
              isPresented: $isShowDeleteDialog,
              actions: {
                Button("No", role: .cancel) {
                  isShowDeleteDialog = false
                }
                Button("Yes") {
                  Task {
                    // TODO: nil Handling
                    do {
                      isShowDeleteDialog = false
                      try await entrancePageViewModel.documentRepository.deleteDocument(
                        device_id: Util.getDeviceUUID() ?? "")
                      launchPageViewModel.deviceRegisterState = .notRegisterd
                    }
                  }
                }
              }
            ) {
              Text(
                "Your device will be out of management and you will not be able to find your device. Are you sure?"
              )
            }
          }
          Spacer()
        }.zIndex(1)
      }
    }
  }
}

#Preview{
  EntrancePage()
}
