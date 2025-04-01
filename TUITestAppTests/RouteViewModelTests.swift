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
}
