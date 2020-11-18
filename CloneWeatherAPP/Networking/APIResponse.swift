//
//  APIResponse.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/17.
//

import Foundation

//MARK: APIResult

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

//MARK: APIResponse
struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

//Mark: APIResponse Extension <- 이해가 안됨... 제네릭 + 데이터 개념 다시 공부하기
extension APIResponse where Body == Data? {
    func deocode<T: Decodable>(to type: T.Type) throws -> APIResponse<T> {  // throws : 오류를 처리해주는 곳으로 전달하는 역할
        guard let data = body else {
            throw APIError.dataFailed
        }
        
        guard let decodedJSON = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.decodingFailed
        }
        
        return APIResponse<T>(statusCode: self.statusCode, body: decodedJSON)
    }
}

