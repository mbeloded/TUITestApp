//
//  RouteFinder.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import Foundation

final class RouteFinder: RouteFinding {
    private var graph: [String: [Connection]] = [:]

    init(connections: [Connection]) {
        buildGraph(from: connections)
    }

    private func buildGraph(from connections: [Connection]) {
        for connection in connections {
            graph[connection.from, default: []].append(connection)
        }
    }
    
    var allCities: [City] {
        let allNames = Set(graph.keys + graph.values.flatMap { $0.map { $0.to } })
        return allNames.map { City(name: $0) }
    }

    func findCheapestRoute(from: City, to: City) -> Route? {
        var distances: [String: Int] = [:]
        var previous: [String: Connection] = [:]
        var visited: Set<String> = []

        var pq = PriorityQueue<(city: String, cost: Int)> { $0.cost < $1.cost }
        pq.enqueue((city: from.name, cost: 0))
        distances[from.name] = 0

        while let (currentCity, currentCost) = pq.dequeue() {
            if visited.contains(currentCity) { continue }
            visited.insert(currentCity)

            if currentCity == to.name {
                break
            }

            for connection in graph[currentCity] ?? [] {
                let neighbor = connection.to
                let newCost = currentCost + connection.price

                if distances[neighbor, default: Int.max] > newCost {
                    distances[neighbor] = newCost
                    previous[neighbor] = connection
                    pq.enqueue((city: neighbor, cost: newCost))
                }
            }
        }

        // Reconstruct path
        var path: [Connection] = []
        var currentCity = to.name

        while let connection = previous[currentCity] {
            path.insert(connection, at: 0)
            currentCity = connection.from
        }

        guard !path.isEmpty, path.first?.from == from.name else {
            return nil // No route found
        }

        return Route(connections: path)
    }
}

