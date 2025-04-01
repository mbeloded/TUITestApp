//
//  RoutingProtocol.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

protocol RouteFinding {
    func fetchCities() -> [City]
    func findRoute(from: City, to: City) -> Route?
}
