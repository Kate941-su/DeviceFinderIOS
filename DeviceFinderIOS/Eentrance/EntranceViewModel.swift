//
//  EntranceViewMoodel.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/29.
//

import Foundation
import SwiftUI

class EntranceViewModel: ObservableObject {
  let documentRepository: DocumentRepository

  @Published var path = NavigationPath()
  @Published var isShowDeleteDialog = false
  @Published var isFetching = false

  init(documentRepository: DocumentRepository) {
    self.documentRepository = documentRepository
  }
}
