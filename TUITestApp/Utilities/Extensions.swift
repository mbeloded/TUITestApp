//
//  Extensions.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

extension Array where Element == Connection {
    func allUniqueCities() -> [City] {
        var cities = Set<String>()
        for conn in self {
            cities.insert(conn.from)
            cities.insert(conn.to)
        }
        return cities.map { City(name: $0) }.sorted { $0.name < $1.name }
    }
}
