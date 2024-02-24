//
//  WaitingIndicatorStyle.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/24.
//

import SwiftUI

struct WaitingIndicatorStyle: ProgressViewStyle {

  var color: Color
  var lineWidth: CGFloat
  
  func makeBody(configuration: Configuration) -> some View {
    let fractionCompleted = configuration.fractionCompleted ?? 0
    
    return ZStack {
      Circle()
        .trim(from: 0, to: fractionCompleted)
        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        .rotationEffect(.degrees(-90))
    }
  }
}
