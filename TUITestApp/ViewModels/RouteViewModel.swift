//
//  RouteViewModel.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import Foundation
import Combine
import SwiftUI

enum RouteFindingError: LocalizedError, Equatable {
    case noRoute
    case invalidCities
    case loadingConnectionsFailed(String)

    var errorDescription: String? {
        switch self {
        case .noRoute:
            return "No route found"
        case .invalidCities:
            return "Invalid cities"
        case .loadingConnectionsFailed(let message):
            return message
        }
    }
}

@MainActor
protocol RouteViewModelProtocol: ObservableObject, Sendable {
    var allCities: [City] { get }
    var route: Route? { get }
    var errorMessage: RouteFindingError? { get }

    var fromCity: City? { get set }
    var toCity: City? { get set }

    func findRoute()
    func loadCities()
}

@MainActor
final class RouteViewModel: RouteViewModelProtocol {

    private var routeFinder: RouteFinding
    private let connectionsService: ConnectionsFetching

    @Published private(set) var allCities: [City] = []
    @Published private(set) var route: Route?
    @Published private(set) var errorMessage: RouteFindingError?

    @Published var fromCity: City?
    @Published var toCity: City?

    init(routeFinder: RouteFinding = RouteFinder(connections: []), connectionsService: ConnectionsFetching) {
        self.routeFinder = routeFinder
        self.connectionsService = connectionsService
    }

    func loadCities() {
        connectionsService.fetchConnections { [weak self] result in
            guard let self else { return }

            Task { @MainActor in
                switch result {
                case .success(let connections):
                    guard !connections.isEmpty else {
                        self.errorMessage = .loadingConnectionsFailed("No available connections.")
                        return
                    }
                    let finder = RouteFinder(connections: connections)
                    self.routeFinder = finder
                    self.allCities = connections.allUniqueCities()

                case .failure(let error):
                    self.errorMessage = .loadingConnectionsFailed(error.localizedDescription)
                }
            }
        }
    }

    func findRoute() {
        guard let fromCity, let toCity else {
            errorMessage = .invalidCities
            return
        }

        if let route = routeFinder.findCheapestRoute(from: fromCity, to: toCity) {
            self.route = route
        } else {
            self.errorMessage = .noRoute
        }
    }
}
