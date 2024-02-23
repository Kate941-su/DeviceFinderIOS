//
//  LaunchPageInteractor.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/21.
//

import Foundation
import Combine

class LaunchPageInteractor: ObservableObject {
  @Published var hasRegistered: Bool = false
}


class LaunchStateObject: ObservableObject {
  @Published var state: LaunchState = .fetching
}

enum LaunchState {
  case fetching
  case notRegisterd
  case registerd
}
