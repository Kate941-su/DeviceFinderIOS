////
////  ButtonModifier.swift
////  DeviceFinderIOS
////
////  Created by KaitoKitaya on 2024/02/26.
////
//
//import SwiftUI
//
//struct ButtonModifier: ViewModifier {
//  let width: CGFloat
//  let backGroundColor: Color
//
//  func body(content: Content) -> some View {
//    content
//      .bold()
//      .padding()
//      .frame(width: width, height: 50, alignment: .center)
//      .foregroundColor(Color.white)
//      .background(backGroundColor)
//      .clipShape(RoundedRectangle(cornerRadius: 24))
//      .opacity(disabled ? 0.5 : 1.0)
//    }
//}
//
//extension View {
//  func customButtonStyle() -> some View {
//    self.modifier(ButtonModifier())
//  }
//}
//
//#Preview {
//    ButtonModifier()
//}
