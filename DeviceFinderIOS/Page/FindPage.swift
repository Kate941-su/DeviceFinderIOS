//
//  FindPage.swift
//  DeviceFinderIOS
//
//  Created by KaitoKitaya on 2024/02/18.
//

import SwiftUI
import Combine
import MapKit

// unit: m
let baseScale:CLLocationDistance = 100

struct FindPage: View {
  
  @State var deviceId: String = ""
  @State var password: String = ""
  
  // GeoLocationService
  @StateObject var geoLocationService = GeoLocationService.shared
  @State var tokens: Set<AnyCancellable> = []
  @State var coordinates: Coordinates = Coordinates(latitude: 0.0, logitude: 0.0)
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
                          latitude: CLLocationDegrees(coordinates.latitude),
                          longitude: CLLocationDegrees(coordinates.longitude)),
                          latitudinalMeters: baseScale,
                          longitudinalMeters: baseScale
                        )
              print($region)
              isTappedFind = true
            }
            Spacer()
          }.padding()
          if isTappedFind {
            // TODO: Use bounds, interactionModes: scope if OS version >= iOS 17
            Text("latitude: \(coordinates.latitude)")
              .padding()
            Text("longitude: \(coordinates.longitude)")
              .padding()
            Map(
              coordinateRegion: $region,
              interactionModes: .all,
              showsUserLocation: false
            )
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
        self.coordinates = Coordinates(latitude: coordinates.latitude, logitude: coordinates.longitude)
      }.store(in: &tokens)
  }

  private func observeLocationAccessDenied() {
    geoLocationService.deniedLocationAccessPublisher.receive(on: DispatchQueue.main)
      .sink {
        // TODO: Lost geolocation data error handling
        print("Show some kind of alert to the user")
      }.store(in: &tokens)
  }
}

#Preview {
    FindPage()
}
