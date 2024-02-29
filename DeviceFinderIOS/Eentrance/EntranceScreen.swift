//
//  EntranceScreen.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

// TODO: Update NavigationStack With Path
// https://qiita.com/yoshi-eng/items/91666637cd7cdd8edf88

struct EntranceScreen: View {
  
  @EnvironmentObject var deviceRegisterStateNotifier: DeviceRegisterStateNotifier
  @StateObject var entranceViewModel: EntranceViewModel

  var body: some View {
    NavigationStack(path: $entranceViewModel.path) {
      ZStack {
        if entranceViewModel.isFetching {
          ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2.0)
        }
        VStack {
          Spacer()
          NavigationLink(
            value: Router.findPageRoute,
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
          if deviceRegisterStateNotifier.state == .notRegisterd {
            NavigationLink(
              value: Router.registerPageRoute,
              label: {
                TextButton(
                  text: "Register",
                  textColor: Color.white,
                  backGroundColor: Color.green)
              }
            )
          } else if deviceRegisterStateNotifier.state == .registered {
            TextButton(
              text: "Delete",
              textColor: Color.white,
              backGroundColor: Color.red
            )
            .onTapGesture {
              print("Delete tapped")
              entranceViewModel.isShowDeleteDialog = true
            }
            .alert(
              "Confirmation",
              isPresented: $entranceViewModel.isShowDeleteDialog,
              actions: {
                Button("No", role: .cancel) {
                  entranceViewModel.isShowDeleteDialog = false
                }
                Button("Yes") {
                  Task {
                    defer {
                      entranceViewModel.isFetching = false
                      entranceViewModel.isShowDeleteDialog = false
                    }
                    // TODO: nil Handling
                    do {
                      entranceViewModel.isFetching = true
                      try await entranceViewModel.documentRepository.deleteDocument(
                        device_id: Util.getDeviceUUID() ?? "", completion: nil)
                      deviceRegisterStateNotifier.state = .notRegisterd
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
              text: "Update",
              textColor: Color.white,
              backGroundColor: Color.orange
            )
          }
          Spacer()
        }
        .zIndex(1)
        //TODO: Navigation Item Text (https://stackoverflow.com/questions/59820540/default-text-for-back-button-in-navigationview-in-swiftui)
        .navigationDestination(
          for: Router.self,
          destination: { it in
            it.Destination(documentRepository: entranceViewModel.documentRepository)
              .navigationTitle(it.title)
              .navigationBarTitleDisplayMode(.inline)
          })
      }
      .environmentObject(deviceRegisterStateNotifier)
      .navigationTitle(Router.entrancePageRoute.title)
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview{
  EntranceScreen(entranceViewModel: EntranceViewModel(documentRepository: DocumentRepositoryImpl()))
}
