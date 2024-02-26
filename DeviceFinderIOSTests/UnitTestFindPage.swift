//
//  UnitTestFindPage.swift
//  DeviceFinderIOSTests
//
//  Created by KaitoKitaya on 2024/02/26.
//

import XCTest
@testable import DeviceFinderIOS

final class UnitTestFindPage: XCTestCase {
    
  func testFindDevice() async throws {
    
    let mockedPage = FindPage(documentRepository: MockedDocumentRepository())
    
    let result = await mockedPage.findDevice(device_id: "", device_password: "")

    // Device Found Case
    XCTAssertEqual(result?.device_id, mockedDevice.device_id)
    XCTAssertEqual(result?.device_password, mockedDevice.device_password)
  }
  
  
    // Default Generated Codes
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
