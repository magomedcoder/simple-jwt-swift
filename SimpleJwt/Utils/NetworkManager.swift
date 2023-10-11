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
    private var jwtToken: String?

    private init() {
        session = Session()
    }
    
    private func fullURL(forPath path: String) -> URL {
        if let url = URL(string: baseURL + path) {
            return url
        }
        fatalError("Invalid URL")
    }
    
    func setJWTToken() {
        jwtToken = UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var jwtHeader: HTTPHeaders {
        if let token = jwtToken {
            return HTTPHeaders(["Authorization": "Bearer \(token)"])
        } else {
            return HTTPHeaders()
        }
    }
    
    private func isTokenValid() -> Bool {
        guard let token = jwtToken,
              let jwt = JWTDecode(token: token) else {
            return false
        }

        let expirationDate = Date(timeIntervalSince1970: jwt.payload.expiresIn)
        let currentDate = Date()

        return currentDate < expirationDate
    }
    
    private func performRequest(url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<Data, Error>) -> Void) {
        if !isTokenValid() {
            refresh { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let res = try JSONDecoder().decode(LoginModel.self, from: data)
                        UserDefaults.standard.set("access_token", forKey: res.access)
                        self?.jwtToken = res.access
                    } catch {
                        print(error)
                    }
                    self?.performRequest(url: url, method: method, parameters: parameters, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            session.request(url, method: method, parameters: parameters, headers: jwtHeader)
                .validate()
                .responseData { [weak self] response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode, statusCode == 401 {
                            self?.refresh { [weak self] result in
                                switch result {
                                case .success(let data):
                                    do {
                                        let res = try JSONDecoder().decode(LoginModel.self, from: data)
                                        UserDefaults.standard.set("access_token", forKey: res.access)
                                        self?.jwtToken = res.access
                                    } catch {
                                        print(error)
                                    }
                                    self?.performRequest(url: url, method: method, parameters: parameters, completion: completion)
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
        }
    }

    func refresh(completion: @escaping (Result<Data, Error>) -> Void) {
        if let refreshURL = URL(string: baseURL + "/api/refresh/") {
            if let refresh = UserDefaults.standard.string(forKey: "refresh_token") {
                let parameters: [String: Any] = ["refresh": refresh]
                performRequest(
                    url: refreshURL,
                    method: .post,
                    parameters: parameters,
                    completion: completion
                )
            }
        } else {
            fatalError("Неверный URL-адрес для обновления токена")
        }
    }
    
    func get(
        path: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let url = fullURL(forPath: path)
        performRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }
    
    func post(
        path: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let url = fullURL(forPath: path)
        performRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    func put(
        path: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let url = fullURL(forPath: path)
        performRequest(url: url, method: .put, parameters: parameters, completion: completion)
    }
    
    func delete(
        path: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let url = fullURL(forPath: path)
        performRequest(url: url, method: .delete, parameters: parameters, completion: completion)
    }
    
}
