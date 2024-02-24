//
//  LaunchPageInteractor.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/21.
//

import Combine
import Foundation

enum DeviceRegisterState {
  case pending
  case notRegisterd
  case registered
}

class LaunchPageViewModel: ObservableObject {
  @Published var deviceRegisterState: DeviceRegisterState = .pending
}
