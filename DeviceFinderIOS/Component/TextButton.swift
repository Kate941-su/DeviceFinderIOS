//
//  TextButton.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI

struct TextButton: View {
  let text: String
  let textColor: Color
  let backGroundColor: Color
  var callback: (() -> Void)?

  init(text: String, textColor: Color, backGroundColor: Color, callback: (() -> Void)? = nil) {
    self.text = text
    self.backGroundColor = backGroundColor
    self.textColor = textColor
    self.callback = callback
  }

  @State var isTapped = false

  var body: some View {
    Text(text)
      .multilineTextAlignment(.center)
      .bold()
      .padding()
      .frame(width: 100, height: 50, alignment: .center)
      .foregroundColor(Color.white)
      .background(backGroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 24))
  }
}

#Preview{
  TextButton(
    text: "Demo",
    textColor: Color.white,
    backGroundColor: Color.blue
  ) {

  }
}
