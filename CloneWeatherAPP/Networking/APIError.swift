//
//  APIError.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/17.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case requestFailed
    case networkFailed
    case decodingFailed
    case dataFailed
    
    public var localizedDescription: String {
        switch self {   // 이렇게 self로 작성할 수 있다는 것도 체크해두기
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFailed:
            return "요청 실패"
        case .networkFailed:
            return "네트워크 에러"
        case .decodingFailed:
            return "디코딩 실패"
        case .dataFailed:
            return "잘못된 데이터입니다."
        }
    }
}
