//
//  RouteViewModelTests.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//
import XCTest
@testable import TUITestApp

final class RouteViewModelTests: XCTestCase {
    func test_whenCitiesAreSet_shouldExposeThemViaPublisher() {
        let mockRouteFinder = MockRouteFinder()
        let viewModel = RouteViewModel(routeFinder: mockRouteFinder)

        let expectation = XCTestExpectation(description: "Should receive all cities")
        var receivedCities: [City] = []

        let cancellable = viewModel.allCitiesPublisher
            .sink { cities in
                receivedCities = cities
                expectation.fulfill()
            }

        mockRouteFinder.mockCities = [
            City(name: "Berlin"),
            City(name: "Paris")
        ]

        viewModel.loadCities()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedCities.count, 2)
        XCTAssertEqual(receivedCities.map(\.name), ["Berlin", "Paris"])
        cancellable.cancel()
    }
    
    func test_findRoute_shouldReturnCorrectRoute() {
        // Given
        let mockRouteFinder = MockRouteFinder()
        let viewModel = RouteViewModel(routeFinder: mockRouteFinder)

        let berlin = City(name: "Berlin")
        let paris = City(name: "Paris")
        let expectedRoute = Route(connections: [
            Connection(
                from: berlin.name,
                to: paris.name,
                coordinates: .init(from: .init(lat: 0, long: 0), to: .init(lat: 1, long: 1)),
                price: 100)
        ])

        mockRouteFinder.mockRoute = expectedRoute
        viewModel.fromCity = berlin
        viewModel.toCity = paris

        let expectation = XCTestExpectation(description: "Route should be published")
        var receivedRoute: Route?

        let cancellable = viewModel.routePublisher
            .sink { route in
                receivedRoute = route
                expectation.fulfill()
            }

        // When
        viewModel.findRoute()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedRoute, expectedRoute)
        cancellable.cancel()
    }

}
