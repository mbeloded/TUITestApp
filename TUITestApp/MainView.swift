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
    @State private var activeTextField: ActiveField?
    @State private var region = MKCoordinateRegion(
       center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
       span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
   )

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            TextField("From", text: $fromInput)
                                .textFieldStyle(.roundedBorder)
                                .submitLabel(.next)
                                .onTapGesture {
                                    activeTextField = .from
                                    showSuggestions = true
                                }
                                .onChange(of: fromInput) { _, _ in
                                    activeTextField = .from
                                    showSuggestions = true
                                }
                                .onSubmit {
                                    showSuggestions = false
                                    activeTextField = .to
                                }

                            TextField("To", text: $toInput)
                                .textFieldStyle(.roundedBorder)
                                .submitLabel(.done)
                                .onTapGesture {
                                    activeTextField = .to
                                    showSuggestions = true
                                }
                                .onChange(of: toInput) { _, _ in
                                    activeTextField = .to
                                    showSuggestions = true
                                }
                                .onSubmit {
                                    showSuggestions = false
                                }
                        }

                        Button("Find Cheapest Route") {
                            viewModel.fromCity = viewModel.allCities.first {
                                $0.name.caseInsensitiveCompare(fromInput) == .orderedSame
                            }
                            viewModel.toCity = viewModel.allCities.first {
                                $0.name.caseInsensitiveCompare(toInput) == .orderedSame
                            }
                            viewModel.findRoute()
                            showSuggestions = false
                        }
                        .buttonStyle(.borderedProminent)

                        Group {
                            if let price = viewModel.route?.totalPrice {
                                Text("Total Price: \(price) €")
                            } else {
                                Text(" ")
                            }
                        }
                        .font(.title3)
                        .frame(height: 30)

                        RouteMapView(route: viewModel.route)
                            .frame(height: 300)
                            .cornerRadius(10)

                        Spacer(minLength: 40)
                    }
                    .padding()
                }

                // Floating Suggestion List
                if showSuggestions {
                    VStack(spacing: 0) {
                        if activeTextField == .from || activeTextField == .to {
                            List(filteredCities, id: \.name) { city in
                                Button(action: {
                                    switch activeTextField {
                                    case .from:
                                        fromInput = city.name
                                    case .to:
                                        toInput = city.name
                                    case .none:
                                        break
                                    }

                                    DispatchQueue.main.async {
                                        showSuggestions = false
                                    }
                                }) {
                                    Text(city.name)
                                        .accessibilityIdentifier(city.name)
                                }
                            }
                            .frame(height: 150)
                            .listStyle(.plain)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                            .transition(.opacity)
                        }
                    }
                    .padding(.top, 100) // Position below fields
                }
            }
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
        let query: String
        switch activeTextField {
        case .from:
            query = fromInput
        case .to:
            query = toInput
        case .none:
            query = ""
        }
        return viewModel.allCities.filter { $0.name.lowercased().contains(query.lowercased()) }
    }

    private func routeAnnotations(from route: Route) -> [AnnotationItem] {
        guard !route.connections.isEmpty else { return [] }

        var coordinates = route.connections.map { $0.coordinates.from.coordinate }

        if let lastToCoordinate = route.connections.last?.coordinates.to.coordinate {
            coordinates.append(lastToCoordinate)
        }

        if let center = coordinates.first {
            region.center = center
        }

        return coordinates.map { AnnotationItem(coordinate: $0) }
    }

}

