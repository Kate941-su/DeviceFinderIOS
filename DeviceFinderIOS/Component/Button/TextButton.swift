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
  var width: CGFloat
  var height: CGFloat

  init(
    text: String, textColor: Color, backGroundColor: Color,
    width: CGFloat? = 120, height: CGFloat? = 48, callback: (() -> Void)? = nil
  ) {
    self.text = text
    self.backGroundColor = backGroundColor
    self.textColor = textColor
    self.callback = callback
    self.width = width!
    self.height = height!
  }

  var body: some View {
    Text(text)
      .multilineTextAlignment(.center)
      .bold()
      .padding()
      .frame(width: width, height: height, alignment: .center)
      .foregroundColor(Color.white)
      .background(backGroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 24))
  }
}

#Preview{
  TextButton(
    text: "KKKK",
    textColor: Color.white,
    backGroundColor: Color.blue
  ) {

  }
}
