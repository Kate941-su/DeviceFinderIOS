//
//  LaunchPageUiTest.swift
//  DeviceFinderIOSUITests
//
//  Created by KaitoKitaya on 2024/02/26.
//

import XCTest

@testable import DeviceFinderIOS

final class LaunchPageUiTests: XCTestCase {

  private var app: XCUIApplication!

  override func setUpWithError() throws {
    app = XCUIApplication()

    app.launch()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  //    func testLaunchPerformance() throws {
  //        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
  //            // This measures how long it takes to launch your application.
  //            measure(metrics: [XCTApplicationLaunchMetric()]) {
  //                XCUIApplication().launch()
  //            }
  //        }
  //    }
}
