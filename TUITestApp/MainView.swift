//
//  MainView.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 11.04.2025.
//

import SwiftUI
import MapKit

struct MainView<ViewModel: RouteViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    @State private var fromInput: String = ""
    @State private var toInput: String = ""
    @State private var showSuggestions = false
    @State private var showAlert = false
    @State private var region = MKCoordinateRegion(
       center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
       span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
   )

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("From", text: $fromInput)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: fromInput) { _, _ in
                        showSuggestions = true
                    }

                TextField("To", text: $toInput)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: toInput) { _, _ in
                        showSuggestions = true
                    }

                Button("Find Cheapest Route") {
                    viewModel.fromCity = viewModel.allCities.first { $0.name.caseInsensitiveCompare(fromInput) == .orderedSame }
                    viewModel.toCity = viewModel.allCities.first { $0.name.caseInsensitiveCompare(toInput) == .orderedSame }
                    viewModel.findRoute()
                }
                .buttonStyle(.borderedProminent)

                if let price = viewModel.route?.totalPrice {
                    priceLabel(price)
                }

                if showSuggestions {
                    List(filteredCities, id: \ .name) { city in
                        Button(city.name) {
                            if fromInput.isEmpty {
                                fromInput = city.name
                            } else {
                                toInput = city.name
                            }
                            showSuggestions = false
                        }
                    }
                    .frame(height: 150)
                }

                if let route = viewModel.route {
                    RouteMapView(route: route)
                        .frame(height: 300)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Route Finder")
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage?.localizedDescription ?? "Unknown error")
            }
            .onChange(of: viewModel.errorMessage) { _, _ in
                showAlert = viewModel.errorMessage != nil
            }
            .onAppear {
                viewModel.loadCities()
            }
        }
    }

    private func priceLabel(_ price: Int) -> some View {
        Text("Total Price: \(price) €")
            .font(.title3)
            .padding()
    }

    private var filteredCities: [City] {
        let query = fromInput.isEmpty ? toInput : fromInput
        return viewModel.allCities.filter { $0.name.lowercased().contains(query.lowercased()) }
    }

    private func routeAnnotations(from route: Route) -> [AnnotationItem] {
        let coordinates = route.connections.map(\ .coordinates.from.coordinate) + [route.connections.last!.coordinates.to.coordinate]
        if let center = coordinates.first {
            region.center = center
        }
        return coordinates.map { AnnotationItem(coordinate: $0) }
    }
}

