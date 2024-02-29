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

  // MEMO: Thanks to @ViewBuilder, you can contain multiple View components in the View closure.
  @ViewBuilder
  func Destination(documentRepository: DocumentRepository) -> some View {
    let documentRepositoryImpl = DocumentRepositoryImpl()
    switch self {
    case .entrancePageRoute:
      EntranceScreen(
        entranceViewModel: EntranceViewModel(documentRepository: documentRepositoryImpl))

    case .findPageRoute:
      DeviceFindScreen(
        deviceFindViewModel: DeviceFindViewModel(documentRepository: documentRepositoryImpl))

    case .registerPageRoute:
      RegisterScreen(
        registerViewModel: RegisterViewModel(documentRepository: documentRepositoryImpl))

    case .foundLocationPageRoute: DeviceFoundScreen()
    }
  }
}
