//
//  MockCOnnectionService.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 02.04.2025.
//
@testable import TUITestApp

final class MockConnectionsService: ConnectionsFetching {
    var mockConnections: [Connection] = []

    func fetchConnections(completion: @escaping @Sendable (Result<[Connection], Error>) -> Void) {
        completion(.success(mockConnections))
    }
}
