//
//  ConnectionsService.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import Foundation

enum ConnectionsServiceError: Error {
    case missingURL
    case invalidData
}

protocol ConnectionsFetching {
    func fetchConnections(completion: @escaping @Sendable (Result<[Connection], Error>) -> Void)
}

final class ConnectionsService: ConnectionsFetching, @unchecked Sendable {
    private let url: URL?

    init() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "ConnectionsDataURL") as? String {
            self.url = URL(string: urlString)
        } else {
            self.url = nil
        }
    }

    func fetchConnections(completion: @escaping @Sendable (Result<[Connection], Error>) -> Void) {
        guard let url else {
            completion(.failure(ConnectionsServiceError.missingURL))
            return
        }

        URLSession.shared.dataTask(with: url) { [completion] data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(ConnectionsServiceError.invalidData))
                return
            }

            do {
                let response = try JSONDecoder().decode(ConnectionsResponse.self, from: data)
                completion(.success(response.connections))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
