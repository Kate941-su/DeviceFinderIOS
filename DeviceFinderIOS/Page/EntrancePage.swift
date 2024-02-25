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

  let documentRepository: DocumentRepository = DocumentRepositoryImpl()
  @EnvironmentObject var launchPageViewModel: LaunchPageViewModel

  @State private var path = NavigationPath()
  @State private var isShowDeleteDialog = false
  @State private var isFetching = false

  var body: some View {
    NavigationStack(path: $path) {
      ZStack {
        if isFetching {
          ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2.0)
        }
        VStack {
          Spacer()
          NavigationLink(
            value: Router.findPageRote, label: {
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
              value: Router.registerPageRote,
              label: {
                TextButton(
                  text: "Register",
                  textColor: Color.white,
                  backGroundColor: Color.green)
              }
            )
          } else if (launchPageViewModel.deviceRegisterState == .registered) {
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
                    defer {
                      isFetching = false
                      isShowDeleteDialog = false
                    }
                    // TODO: nil Handling
                    do {
                      isFetching = true
                      try await documentRepository.deleteDocument(
                        device_id: Util.getDeviceUUID() ?? "", completion: nil)
                      launchPageViewModel.deviceRegisterState = .notRegisterd
                    } catch {
                      print(error)
                    }
                  }
                }
              }
            ) {
              Text(
                "Your device will be out of management and you will not be able to find your device. Are you sure?"
              )
            }
            Spacer()
            Divider()
            Spacer()
            TextButton(
              text: "Update Location",
              textColor: Color.white,
              backGroundColor: Color.orange
            )
          }
          Spacer()
        }
        .zIndex(1)
        .navigationDestination(for: Router.self, destination: { it in
          if it == .findPageRote {
            FindPage()
          } else if it == .registerPageRote {
            RegisterPage()
          }
        })
      }
      .environmentObject(launchPageViewModel)
    }
  }
}

#Preview{
  EntrancePage()
}
