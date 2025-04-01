//
//  MockRouteFinder.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

@testable import TUITestApp

final class MockRouteFinder: RouteFinding {
    var mockCities: [City] = []
    var mockRoute: Route?

    func fetchCities() -> [City] {
        return mockCities
    }

    func findRoute(from: City, to: City) -> Route? {
        return mockRoute
    }
}
