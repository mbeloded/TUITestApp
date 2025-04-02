//
//  RouteViewModel.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import Foundation
import Combine

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
protocol RouteViewModelProtocol: Sendable {
    var allCitiesPublisher: AnyPublisher<[City], Never> { get }
    var routePublisher: AnyPublisher<Route?, Never> { get }
    var errorMessagePublisher: AnyPublisher<RouteFindingError?, Never> { get }

    var fromCity: City? { get set }
    var toCity: City? { get set }

    func findRoute()
    func loadCities()
}

@MainActor
final class RouteViewModel: RouteViewModelProtocol {

    private var routeFinder: RouteFinding
    private let connectionsService: ConnectionsFetching

    private let citiesSubject = CurrentValueSubject<[City], Never>([])
    private let routeSubject = CurrentValueSubject<Route?, Never>(nil)
    private let errorMessageSubject = CurrentValueSubject<RouteFindingError?, Never>(nil)

    var fromCity: City?
    var toCity: City?

    var allCitiesPublisher: AnyPublisher<[City], Never> {
        citiesSubject.eraseToAnyPublisher()
    }

    var routePublisher: AnyPublisher<Route?, Never> {
        routeSubject.eraseToAnyPublisher()
    }

    var errorMessagePublisher: AnyPublisher<RouteFindingError?, Never> {
        errorMessageSubject.eraseToAnyPublisher()
    }

    init(routeFinder: RouteFinding = RouteFinder(connections: []), connectionsService: ConnectionsFetching) {
        self.routeFinder = routeFinder
        self.connectionsService = connectionsService
    }

    func loadCities() {
        connectionsService.fetchConnections { [weak self] result in
            guard let self = self else { return }

            Task { @MainActor in
                switch result {
                case .success(let connections):
                    guard !connections.isEmpty else {
                        self.errorMessageSubject.send(.loadingConnectionsFailed("No available connections."))
                        return
                    }
                    let finder = RouteFinder(connections: connections)
                    self.routeFinder = finder
                    self.citiesSubject.send(finder.allCities)

                case .failure(let error):
                    self.errorMessageSubject.send(.loadingConnectionsFailed(error.localizedDescription))
                }
            }
        }
    }

    func findRoute() {
        guard let fromCity, let toCity else {
            errorMessageSubject.send(.invalidCities)
            return
        }

        if let route = routeFinder.findCheapestRoute(from: fromCity, to: toCity) {
            routeSubject.send(route)
        } else {
            errorMessageSubject.send(.noRoute)
        }
    }
}
