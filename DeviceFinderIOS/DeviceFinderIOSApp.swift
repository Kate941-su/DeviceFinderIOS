//
//  DeviceFinderIOSApp.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import FirebaseAppCheck
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
    FirebaseApp.configure()
    return true
  }
}

@main
struct DeviceFinderIOSApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @Environment(\.scenePhase) private var phase
  @StateObject private var deviceRegisterStateNotifier = DeviceRegisterStateNotifier()
  
  // TODO: GeoLocationManageer
  // @StateObject private var location

  var body: some Scene {
    WindowGroup {
      /// You Can Turn On By Editting Arguments in The Scheme
      // Device Factory Page
      if ProcessInfo.processInfo.environment["DB_FACTORY_MODE"] != nil {
        DbFactoryPage()
      } else {
        SplashScreen(documentRepositry: DocumentRepositoryImpl()).environmentObject(deviceRegisterStateNotifier)
      }
    }
    .onChange(of: phase) { newPhase in
      switch newPhase {
      case .background: scheduleAppRefresh()
      default: break
      }
    }
    .backgroundTask(.appRefresh(GEOLOCATION_REFRESH_TASK_IDENTIFIRE)) {
      print("TODO: Write your code you want to execute")
    }
  }
}
