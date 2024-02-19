//
//  Device.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import Foundation
import CryptoKit
import FirebaseFirestore

struct Device: Identifiable, Codable {
  @DocumentID var id: String?
  var position: GeoPoint
  let device_id: String
  let device_password: String
  @ServerTimestamp var update_at: Timestamp?
  
  var hashedDeviceId: String {
    get {
      return device_id.sha256().toString()
    }
  }
  
  var hashedDevicePassword: String {
    get {
      return device_password.sha256().toString()
    }
  }
}

extension String {
  func sha256() -> SHA256Digest {
    return SHA256.hash(data: Data(self.utf8))
  }
}

extension SHA256.Digest {
  public func toString() -> String {
    return self.map{String(format: "%02hhx", $0)}.joined()
  }
}

extension SHA256.Digest {
//  public func toString() -> String {
////    return self.map{String(format: "%02hhx")}.joined()
//  }
}
