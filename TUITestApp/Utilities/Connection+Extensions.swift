//
//  Connection+Extensions.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

extension Array where Element == Connection {
    func allUniqueCities() -> [City] {
        let names = self.flatMap { [$0.from, $0.to] }
        let unique = Set(names)
        return unique.map { City(name: $0) }.sorted { $0.name < $1.name }
    }
}
