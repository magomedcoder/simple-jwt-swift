//
//  Models.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import Foundation

struct LoginModel: Codable {
    var access: String
}

struct UserModel: Codable {
    var count: Int
}
