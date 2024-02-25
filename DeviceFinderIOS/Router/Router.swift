//
//  Router.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/21.
//

import Foundation
import SwiftUI

enum Router: Int {
  case entrancePageRoute, findPageRoute, registerPageRoute, foundLocationPageRoute

  var title: String {
    switch self {
    case .entrancePageRoute: "Home"
    case .findPageRoute: "Find"
    case .registerPageRoute: "Register"
    case .foundLocationPageRoute: "FoundLocationPage"
    }
  }

  @ViewBuilder
  func Destination() -> some View {
    switch self {
    case .entrancePageRoute: EntrancePage()
    case .findPageRoute: FindPage()
    case .registerPageRoute: RegisterPage()
    case .foundLocationPageRoute: FoundLocationPage()
    }
  }
}
