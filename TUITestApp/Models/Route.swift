//
//  Route.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//
import Foundation

struct Route {
    let connections: [Connection]
    var totalPrice: Int {
        connections.reduce(0) { $0 + $1.price }
    }
}
