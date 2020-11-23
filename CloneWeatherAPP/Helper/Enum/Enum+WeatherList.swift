//
//  Enum+WeatherList.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/22.
//

import Foundation

enum WeatherListCellType: Int {
    case City = 0
    case Setting
}

extension WeatherListCellType: CaseIterable {}  // caseIterable 찾아보기
