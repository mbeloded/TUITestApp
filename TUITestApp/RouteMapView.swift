//
//  RouteMapView.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 11.04.2025.
//

import SwiftUI
import MapKit

struct RouteMapView: UIViewRepresentable {
    let route: Route

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)

        let coordinates = route.connections.map(\.coordinates.from.coordinate) +
                          [route.connections.last!.coordinates.to.coordinate]

        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)

        coordinates.forEach { coordinate in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }

        if let first = coordinates.first {
            let region = MKCoordinateRegion(center: first, span: .init(latitudeDelta: 10, longitudeDelta: 10))
            mapView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "CityPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.animatesWhenAdded = true
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}
