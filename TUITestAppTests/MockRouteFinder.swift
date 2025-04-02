//
//  MockRouteFinder.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

@testable import TUITestApp

final class MockRouteFinder: RouteFinding {

    var mockRoute: Route?

    func findCheapestRoute(from: City, to: City) -> Route? {
        return mockRoute
    }
}
