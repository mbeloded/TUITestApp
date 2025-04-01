//
//  connection.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 31.03.2025.
//

struct Connection: Codable, Equatable {
    let from: String
    let to: String
    let coordinates: Coordinates
    let price: Int
}
