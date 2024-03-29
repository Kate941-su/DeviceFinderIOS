//
//  Device.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import CryptoKit
import FirebaseFirestore
import Foundation

struct Device: Identifiable, Codable, Equatable {
  @DocumentID var id: String?
  var position: GeoPoint
  let device_id: String
  let device_password: String
  @ServerTimestamp var update_at: Timestamp?

  var hashedDeviceId: String {
    return device_id.sha256().toString()
  }

  var hashedDevicePassword: String {
    return device_password.sha256().toString()
  }
}

extension String {
  func sha256() -> SHA256Digest {
    return SHA256.hash(data: Data(self.utf8))
  }
}

extension SHA256.Digest {
  public func toString() -> String {
    return self.map { String(format: "%02hhx", $0) }.joined()
  }
}

extension Device {
  static func setDummydevice(geoPoint: GeoPoint, device_id: String, device_password: String)
    -> Device
  {
    let dummyDevice = Device(
      position: geoPoint, device_id: device_id, device_password: device_password)
    return dummyDevice
  }
}
