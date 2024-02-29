//
//  DeviceRegisterState.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/29.
//

import Foundation

enum DeviceRegisterState {
  case pending
  case notRegisterd
  case registered
}

class DeviceRegisterStateNotifier: ObservableObject {
  @Published var state: DeviceRegisterState = .pending
}
