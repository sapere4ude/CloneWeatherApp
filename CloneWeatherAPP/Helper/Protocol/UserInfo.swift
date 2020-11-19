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
        if let cityLists = UserDefaults.standard.value(forKey: cities) as? Data {   // UserDefaults : 데이터 저장소 역할. 앱의 어느 곳에서나 데이터를 쉽게 읽고 저장할 수 있게 된다. 사용자 기본 설정과 같은 단일 데이터 값에 적합하다. 저장 방식은 [데이터, 키(key)]으로 데이터를 저장. 이때 key의 값은 String(문자열)이다.
            // as? <- 특정 타입이 맞는지 확신할 수 없을때 사용 (다운캐스팅). 캐스팅은 실제 인스턴스 값을 바꾸는 것이 아니라 지정한 타입으러 취급하는 것일 뿐이다.
        let cityList = try? PropertyListDecoder().decode([Coordinate].self, from: cityLists) // try? <- 간편한 에러처리 기능. 에러 발생 시 nil을 반환. 에러가 발셍하지 않으면 반환 타입은 옵셔널. 반환 타입 없이 사용할 수 있는 것이 장점.
            return cityList
        }
        return  nil
    }
    
    static func getFahrenheitOrCelsius() -> FahrenheitOrCelsius {
        if let fahrenheitOrCelsius = UserDefaults.standard.string(forKey: fahrenheitOrCelsius),
           let fahrenheitOrCelsiusValue = FahrenheitOrCelsius(rawValue: fahrenheitOrCelsius) {
            return fahrenheitOrCelsiusValue
        }
        return FahrenheitOrCelsius.Celsius
    }
    
}
