//
//  APICenter.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/17.
//

import Foundation

let weatherAPIKey = "/6c3d1f270e06623926fdafa472b4cf61/"

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


struct HTTPHeader {
    let field: String
    let value: String
}

struct APICenter {
    typealias APIClientCompletion = (APIResult<Data?>) -> Void
    
    private let session = URLSession.shared
    
    func perform(urlString: String,
                 request: APIRequest,
                 completion: @escaping APIClientCompletion) {
        guard let baseURL = URL(string: urlString) else {
            completion(.failure(.invalidURL))   // .failure는 APIResult, .invalidURL은 APIError에 있음. completion 은 APIClientCompletion과 연결되어 있고
                                                // .을 작성하면 APIResult의 프로퍼티들이 보이고 한번 더 작성하면 APIError와 관련된 프로퍼티들을 볼 수 있다.
            return
        }
        
        var makeURLComponent = URLComponents()
        makeURLComponent.scheme = baseURL.scheme
        makeURLComponent.host = baseURL.host
        
        if let path = request.path {
            makeURLComponent.path = path
        }
        
        let queryItems = request.queryItems?.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        makeURLComponent.queryItems = queryItems
        
        guard let requestURL = makeURLComponent.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: requestURL) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
            
        }
        task.resume()
    }
    
    func performSync(urlString: String,
                     request: APIRequest,
                     completion: @escaping APIClientCompletion) {
        guard let baseURL = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var makeURLComponent = URLComponents()
        makeURLComponent.scheme = baseURL.scheme
        makeURLComponent.host = baseURL.host
        
        if let path = request.path {
            makeURLComponent.path = path
        }
        
        let queryItems = request.queryItems?.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        makeURLComponent.queryItems = queryItems
        
        guard let requestURL = makeURLComponent.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = session.dataTask(with: requestURL) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)
            
                )
            )
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
