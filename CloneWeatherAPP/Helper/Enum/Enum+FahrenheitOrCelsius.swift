//
//  Enum+FahrenheitOrCelsius.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/18.
//

import Foundation

enum FahrenheitOrCelsius: String {
    case Fahrenheit
    case Celsius
}

extension FahrenheitOrCelsius {
    var stringValue: String {
        return "\(self)"
    }
    
    var emoji: String {
        switch self {
        case .Fahrenheit:
            return "℉"
        case .Celsius:
            return "℃"
        }
    }
}
