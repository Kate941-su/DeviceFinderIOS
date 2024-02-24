//
//  FindPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import Combine
import FirebaseFirestore
import MapKit
import SwiftUI

// unit: meter(m)
let baseScale: CLLocationDistance = 100

struct FindPage: View {

  @State private var deviceId: String = ""
  @State private var password: String = ""

  // GeoLocationService
  @StateObject private var geoLocationService = GeoLocationService.shared
  @State private var tokenList: Set<AnyCancellable> = []
  @State private var geoPoint: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 35.0, longitude: 135.0),
    latitudinalMeters: baseScale,
    longitudinalMeters: baseScale
  )

  @State var isTappedFind: Bool = false

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        Text("Device ID").padding()
        TextField("Enter Device ID", text: $deviceId)
          .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
          .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        Text("Device Password").padding()
        TextField("Enter Device Password", text: $password)
          .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
          .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
        HStack {
          Spacer()
          TextButton(
            text: "Find",
            textColor: Color.white,
            backGroundColor: Color.blue
          )
          .onTapGesture {
            print("On Tapped")
            region = MKCoordinateRegion(
              center: CLLocationCoordinate2D(
                latitude: CLLocationDegrees(geoPoint.latitude),
                longitude: CLLocationDegrees(geoPoint.longitude)),
              latitudinalMeters: baseScale,
              longitudinalMeters: baseScale
            )
            print($region)
            isTappedFind = true
          }
          Spacer()
        }.padding()
        if isTappedFind {
          // TODO: Debug Only
          Text("latitude: \(geoPoint.latitude)")
            .padding()
          Text("longitude: \(geoPoint.longitude)")
            .padding()
          // TODO: End Debug Only
          let place = [MarkerPlace(geoPoint: geoPoint)]

          // TODO: Use bounds, interactionModes: scope if OS version >= iOS 17
          Map(
            coordinateRegion: $region,
            interactionModes: .all,
            annotationItems: place
          ) { place in
            MapMarker(
              coordinate: place.location,
              tint: Color.orange)
          }
        }
        Spacer()
      }.navigationTitle("Find")
    }.onAppear {
      observeCoordinateUpdates()
      observeLocationAccessDenied()
      geoLocationService.requestLocationUpdates()
    }
  }

  private func observeCoordinateUpdates() {
    geoLocationService.coordinatesPublisher.receive(on: DispatchQueue.main)
      .sink {
        completion in
        if case .failure(let error) = completion {
          print(error)
        }
      } receiveValue: { coordinates in
        self.geoPoint = GeoPoint(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude
        )
      }.store(in: &tokenList)
  }

  private func observeLocationAccessDenied() {
    geoLocationService.deniedLocationAccessPublisher.receive(on: DispatchQueue.main)
      .sink {
        // TODO: Open Settings and Get Permission
        print("Show some kind of alert to the user")
      }.store(in: &tokenList)
  }
}

#Preview{
  FindPage()
}
