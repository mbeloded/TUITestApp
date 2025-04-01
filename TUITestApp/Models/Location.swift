//
//  location.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//
import CoreLocation

struct Location: Codable, Equatable {
    let lat: Double
    let long: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
