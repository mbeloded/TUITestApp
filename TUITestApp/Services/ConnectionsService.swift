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
    func fetchConnections(completion: @escaping (Result<[Connection], Error>) -> Void)
}

class ConnectionsService: ConnectionsFetching {
    private let url: URL?

    init() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "ConnectionsDataURL") as? String {
            self.url = URL(string: urlString)
        } else {
            self.url = nil
        }
    }

    func fetchConnections(completion: @escaping (Result<[Connection], Error>) -> Void) {
        guard let url = self.url else {
            completion(.failure(ConnectionsServiceError.missingURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ConnectionsServiceError.invalidData))
                return
            }

            do {
                let response = try JSONDecoder().decode(ConnectionsResponse.self, from: data)
                let connections = response.connections
                completion(.success(connections))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
