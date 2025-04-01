//
//  RouteViewModel.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import Combine

protocol RouteViewModelProtocol {
    var allCitiesPublisher: AnyPublisher<[City], Never> { get }
    var routePublisher: AnyPublisher<Route?, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }

    var fromCity: City? { get set }
    var toCity: City? { get set }
    
    func findRoute()
    func loadCities()
}

final class RouteViewModel: RouteViewModelProtocol {
    
    private let routeFinder: RouteFinding
    private let connectionsService: ConnectionsFetching
    
    private var citiesSubject = CurrentValueSubject<[City], Never>([])
    private var routeSubject = CurrentValueSubject<Route?, Never>(nil)
    private var errorMessageSubject = CurrentValueSubject<String?, Never>(nil)

    var fromCity: City?
    var toCity: City?
    
    var allCitiesPublisher: AnyPublisher<[City], Never> {
        citiesSubject.eraseToAnyPublisher()
    }

    var routePublisher: AnyPublisher<Route?, Never> {
        routeSubject.eraseToAnyPublisher()
    }

    var errorMessagePublisher: AnyPublisher<String?, Never> {
        errorMessageSubject.eraseToAnyPublisher()
    }
    
    func setInitialError(_ message: String) {
        errorMessageSubject.send(message)
    }

    init(routeFinder: RouteFinding, connectionsService: ConnectionsFetching) {
        self.routeFinder = routeFinder
        self.connectionsService = connectionsService
    }

    func loadCities() {
        connectionsService.fetchConnections { [weak self] result in
            switch result {
            case .success(let connections):
                let finder = RouteFinder(connections: connections)
                self?.citiesSubject.send(finder.allCities)
            case .failure(let error):
                self?.errorMessageSubject.send(error.localizedDescription)
            }
        }
    }

    func findRoute() {
        guard let from = fromCity,
              let to = toCity else {
            errorMessageSubject.send("Invalid cities")
            return
        }

        if let route = routeFinder.findCheapestRoute(from: from, to: to) {
            routeSubject.send(route)
        } else {
            errorMessageSubject.send("Failed to find route")
        }
    }
}
