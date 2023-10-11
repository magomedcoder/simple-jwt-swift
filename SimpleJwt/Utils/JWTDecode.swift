//
//  JWTDecode.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import Foundation

struct JWTPayload: Codable {
    let expiresIn: Double

    private enum CodingKeys: String, CodingKey {
        case expiresIn = "exp"
    }
}

struct JWTDecode {
    let payload: JWTPayload
}

extension JWTDecode {
    init?(token: String) {
        let encodedData = { (string: String) -> Data? in
            var encodedString = string
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            switch (encodedString.utf16.count % 4) {
            case 2:
                encodedString = "\(encodedString)=="
            case 3:
                encodedString = "\(encodedString)="
            default:
                break
            }

            return Data(base64Encoded: encodedString)
        }

        let components = token.components(separatedBy: ".")

        guard components.count == 3,
              let payloadData = encodedData(components[1] as String)
        else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        do {
            payload = try decoder.decode(JWTPayload.self, from: payloadData)
        }  catch {
            print(error.localizedDescription)
            print("Ошибка: ", error)
            return nil
        }
    }
}
