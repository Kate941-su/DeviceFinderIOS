//
//  UnitTestFindPage.swift
//  DeviceFinderIOSTests
//
//  Created by KaitoKitaya on 2024/02/26.
//

import XCTest
@testable import DeviceFinderIOS

final class UnitTestFindPage: XCTestCase {
    
  func testFoundDevice() async throws {
    
    let mockedPage = FindPage(documentRepository: MockedDocumentRepository())
    
    let result = await mockedPage.findDevice(device_id: "", device_password: "")

    // Device Found Case
    XCTAssertEqual(result?.device_id, mockedDevice.device_id)
    XCTAssertEqual(result?.device_password, mockedDevice.device_password)
  }
  
  func testNotFoundDevice() async throws {
    
    let mockedPage = FindPage(documentRepository: MockedDocumentRepository())
    
    let result = await mockedPage.findDevice(device_id: "dummy", device_password: "dummy")

    // Device Found Case
    XCTAssertNil(result)
  }
}
