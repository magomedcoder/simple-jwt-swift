//
//  NetworkManager.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = ""
    private var session: Session

    private init() {
        session = Session()
    }
    
    private func fullURL(forPath path: String) -> URL {
        if let url = URL(string: baseURL + path) {
            return url
        }
        fatalError("Invalid URL")
    }
    
    private func performRequest(url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<Data, Error>) -> Void) {
        session.request(url, method: method, parameters: parameters)
            .validate()
            .responseData {[weak self] response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print(error)
                }
            }
    }
  
    func post(
        path: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let url = fullURL(forPath: path)
        performRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
}
