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

    func findRoute()
    func loadCities()
}

final class RouteViewModel: RouteViewModelProtocol {
    private let routeFinder: RouteFinding
    private var citiesSubject = CurrentValueSubject<[City], Never>([])
    private var routeSubject = CurrentValueSubject<Route?, Never>(nil)
    private var errorMessageSubject = CurrentValueSubject<String?, Never>(nil)

    var allCitiesPublisher: AnyPublisher<[City], Never> {
        citiesSubject.eraseToAnyPublisher()
    }

    var routePublisher: AnyPublisher<Route?, Never> {
        routeSubject.eraseToAnyPublisher()
    }

    var errorMessagePublisher: AnyPublisher<String?, Never> {
        errorMessageSubject.eraseToAnyPublisher()
    }

    init(routeFinder: RouteFinding) {
        self.routeFinder = routeFinder
    }

    func loadCities() {
        // Hardcoded or mocked city list for now (in real app: use a CitiesFetching dependency)
        let mockCities = [
            City(name: "Berlin"),
            City(name: "Paris"),
            City(name: "Rome")
        ]
        citiesSubject.send(mockCities)
    }

    func findRoute() {
        // This will be implemented later in another test step
    }
}
