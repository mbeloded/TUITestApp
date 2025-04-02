//
//  RouteViewModelTests.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//
import XCTest
import Combine
@testable import TUITestApp

final class RouteViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func test_whenCitiesAreSet_shouldExposeThemViaPublisher() async {
        // Given
        let mockService = MockConnectionsService()
        let mockRouteFinder = MockRouteFinder() // no longer used for cities, just placeholder

        mockService.mockConnections = [
            Connection(from: "Berlin", to: "Paris",
                       coordinates: .init(from: .init(lat: 0, long: 0), to: .init(lat: 1, long: 1)),
                       price: 100)
        ]

        let viewModel = RouteViewModel(routeFinder: mockRouteFinder, connectionsService: mockService)

        let expectation = XCTestExpectation(description: "Receive cities")
        var received: [City] = []

        let cancellable = viewModel.allCitiesPublisher
            .dropFirst() // wait for update
            .sink { cities in
                received = cities
                expectation.fulfill()
            }

        // When
        viewModel.loadCities()
        await fulfillment(of: [expectation], timeout: 1.0)

        // Then
        XCTAssertEqual(received.count, 2)
        XCTAssertTrue(received.contains { $0.name == "Berlin" })
        XCTAssertTrue(received.contains { $0.name == "Paris" })

        cancellable.cancel()
    }

    @MainActor
    func test_findRoute_shouldReturnCorrectRoute() async {
        let mockRouteFinder = MockRouteFinder()
        let mockService = MockConnectionsService()

        let viewModel = RouteViewModel(routeFinder: mockRouteFinder, connectionsService: mockService)

        let berlin = City(name: "Berlin")
        let paris = City(name: "Paris")
        let expectedRoute = Route(connections: [
            Connection(
                from: berlin.name,
                to: paris.name,
                coordinates: .init(from: .init(lat: 0, long: 0), to: .init(lat: 1, long: 1)),
                price: 100
            )
        ])

        mockRouteFinder.mockRoute = expectedRoute
        viewModel.fromCity = berlin
        viewModel.toCity = paris

        let expectation = XCTestExpectation(description: "Route published")
        var result: Route?

        viewModel.routePublisher
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.findRoute()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(result, expectedRoute)
    }

    @MainActor
    func test_findRoute_shouldPublishError_whenNoRouteFound() async {
        let mockRouteFinder = MockRouteFinder()
        let mockService = MockConnectionsService()

        let viewModel = RouteViewModel(routeFinder: mockRouteFinder, connectionsService: mockService)

        let berlin = City(name: "Berlin")
        let rome = City(name: "Rome")

        mockRouteFinder.mockRoute = nil
        viewModel.fromCity = berlin
        viewModel.toCity = rome

        let expectation = XCTestExpectation(description: "Error published")
        var receivedError: RouteFindingError?

        viewModel.errorMessagePublisher
            .dropFirst()
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.findRoute()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedError, .noRoute)
    }
}
