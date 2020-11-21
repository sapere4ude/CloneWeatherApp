//
//  Extension+Double.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/21.
//

import Foundation

//MARK: Extension+Double
extension Double {
    
    // kelvin to celsius
    func makeCelsius() -> String {
        let argue = self - 273.15
        return String(format: "%.0f", arguments: [argue])
    }
    
    // kelvin to fahrenheit
    func makeFahrenheit() -> String {
        let argue = (self * 9/5) - 459.67
        return String(format: "%.0f", arguments: [argue])
    }
    
    // rounding double to 2 decimal place
    func makeRound() -> Double {
        return (self * 100).rounded() / 100
    }
    
    
    
    
}
