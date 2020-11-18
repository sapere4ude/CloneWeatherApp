//
//  UserInfo.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/18.
//

import Foundation

struct UserInfo {
    static let cities = "cities"
    static let fahrenheitOrCelsius = "fahrenheitOrCelsius"
    
    static func getCityList() -> [Coordinate]? {
        if let cityLists = UserDefaults.standard.value(forKey: cities) as? Data {
            
        }
    }
}
