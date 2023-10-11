//
//  ContentView.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

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

struct LoginResponse: Codable {
    var access: String
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
                let res = try JSONDecoder().decode(LoginResponse.self, from: data)
                JWTTest(token: res.access)
            } catch {
                print(error)
            }
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                onLogin()
            }) {
                Text("Test")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
