//
//  BackgroundTask.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/25.
//

import BackgroundTasks
import Foundation

let GEOLOCATION_REFRESH_TASK_IDENTIFIRE = "refreshGeoLocation"

func scheduleAppRefresh() {
  let backgroundTask = BGAppRefreshTaskRequest(identifier: GEOLOCATION_REFRESH_TASK_IDENTIFIRE)
  backgroundTask.earliestBeginDate = .now.addingTimeInterval(10)  // seconds
  try? BGTaskScheduler.shared.submit(backgroundTask)
  print("Background Task Is Running.")
}
