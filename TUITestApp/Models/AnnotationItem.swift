//
//  AnnotationItem.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 11.04.2025.
//
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
