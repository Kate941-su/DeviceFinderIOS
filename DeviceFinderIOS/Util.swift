//
//  Util.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import Foundation
#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif



class Util {
  static func getDeviceUUID() -> String? {
    #if os(macOS)
    // macOS specific code
    if let uuidString = UserDefaults.standard.string(forKey: "deviceUUID") {
        return uuidString
    } else {
        let uuidString = UUID().uuidString
        UserDefaults.standard.set(uuidString, forKey: "deviceUUID")
        return uuidString
    }
    #elseif os(iOS) || os(tvOS)
    // iOS and tvOS specific code
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    return uuid
    #else
    return nil
    #endif
  }
}
