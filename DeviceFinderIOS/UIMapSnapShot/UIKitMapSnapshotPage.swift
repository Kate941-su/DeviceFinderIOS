//
//  UIKitMapSnapshotPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/27.
//

import MapKit
import SwiftUI

struct UIKitMapSnapshotPage: UIViewRepresentable {
  let region: MKCoordinateRegion

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.region = region
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {}

}
