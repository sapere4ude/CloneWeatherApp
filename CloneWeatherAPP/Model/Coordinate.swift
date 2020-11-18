//
//  Coordinate.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/16.
//

import Foundation

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

extension Coordinate: Equatable {
    static func ==(A: Coordinate, B: Coordinate) -> Bool {
        return A.lat == B.lat && A.lon == B.lon
    }
}
