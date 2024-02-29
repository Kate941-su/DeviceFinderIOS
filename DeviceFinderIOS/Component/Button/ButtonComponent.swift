//
//  ButtonComponent.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/25.
//

import SwiftUI

struct ButtonComponent: View {
  let text: String
  let textColor: Color
  let backGroundColor: Color
  var width: CGFloat? = 120
  var disabled: Bool = false
  var callback: (() -> Void)?

  init(
    text: String, textColor: Color, backGroundColor: Color, disabled: Bool = false,
    width: CGFloat = 120,
    callback: (() -> Void)? = nil
  ) {
    self.text = text
    self.backGroundColor = backGroundColor
    self.textColor = textColor
    self.disabled = disabled
    self.width = width
    self.callback = callback
  }

  @State var isTapped = false

  var body: some View {
    Button(text) {
      guard let callback else { return }
      callback()
    }
    .disabled(disabled)
    .multilineTextAlignment(.center)
    .bold()
    .padding()
    .frame(width: width, height: 50, alignment: .center)
    .foregroundColor(Color.white)
    .background(backGroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .opacity(disabled ? 0.5 : 1.0)
  }
}

#Preview{
  ButtonComponent(
    text: "Update Location",
    textColor: Color.white,
    backGroundColor: Color.blue,
    disabled: false,
    width: 300
  ) {
    print("Button Tapped")
  }
}
