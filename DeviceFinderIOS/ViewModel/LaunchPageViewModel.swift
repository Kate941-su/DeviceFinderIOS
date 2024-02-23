//
//  LaunchPageInteractor.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/21.
//

import Foundation
import Combine

enum DeviceRegisterState {
  case pending
  case notRegisterd
  case registerd
}

class LaunchPageViewModel: ObservableObject {
  @Published var deviceRegisterState: DeviceRegisterState = .pending
}


