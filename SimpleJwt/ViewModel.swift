//
//  ViewModel.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var usernameText: String = ""
    @Published var passwordText: String = ""
    @Published var success: Bool = false
    
    func isAuth() -> Bool {
        return UserDefaults.standard.string(forKey: "access_token") != nil
    }
    
    func onLogin() -> Void {
        let networkManager = NetworkManager.shared

        let parameters: [String: Any] = [
            "username": usernameText,
            "password": passwordText,
        ]

        networkManager.post(path: "/api/login/", parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let res = try JSONDecoder().decode(LoginModel.self, from: data)
                    UserDefaults.standard.set("access_token", forKey: res.access)
                    UserDefaults.standard.set("refresh_token", forKey: res.refresh)
                    self.success = true
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func getUsers() -> Void {
        let networkManager = NetworkManager.shared

        networkManager.setJWTToken()
        
        networkManager.get(path: "/api/users/", parameters: nil) { result in
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
