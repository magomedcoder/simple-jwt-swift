//
//  ViewModel.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import Foundation

class ViewModel: ObservableObject {
    
    func JWTTest(token: String) -> Void {
        if let jwt = JWTDecode(token: token) {
            let header = jwt.header
            let payload = jwt.payload
            let signature = jwt.signature

            let type = header.type
            let algorithm = header.algorithm

            let expiresIn = payload.expiresIn
            
            print(type)
            print(algorithm)
            print(expiresIn)
            print(signature)
        }
    }

    func onLogin() -> Void {
        let networkManager = NetworkManager.shared

        let parameters: [String: Any] = [
            "username": "",
            "password": "",
        ]

        networkManager.post(path: "/api/login/", parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let res = try JSONDecoder().decode(LoginModel.self, from: data)

                    self.JWTTest(token: res.access)
                    
                    self.getUsers(token: res.access)
            
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func getUsers(token: String) -> Void {
        let networkManager = NetworkManager.shared
        
        networkManager.setJWTToken(token: token)
        
        networkManager.get(path: "/scadaapi/users/", parameters: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let res = try JSONDecoder().decode(UserModel.self, from: data)
                    print(res.count)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}
