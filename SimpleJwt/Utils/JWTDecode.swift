//
//  JWTDecode.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import Foundation

struct JWTHeader: Codable {
    let type: String
    let algorithm: String
    
    private enum CodingKeys: String, CodingKey {
        case type = "typ"
        case algorithm = "alg"
    }
}

struct JWTPayload: Codable {
    let expiresIn: Double

    private enum CodingKeys: String, CodingKey {
        case expiresIn = "exp"
    }
}

struct JWTDecode {
    let header: JWTHeader
    let payload: JWTPayload
    let signature: String
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
              let headerData = encodedData(components[0] as String),
              let payloadData = encodedData(components[1] as String)
        else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            header = try decoder.decode(JWTHeader.self, from: headerData)
            payload = try decoder.decode(JWTPayload.self, from: payloadData)
            signature = components[2] as String
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            print("Ключ '\(key)' не найден:", context.debugDescription)
            print("Путь к ключу:", context.codingPath)
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            print("Значение '\(value)' не найдено:", context.debugDescription)
            print("Путь к значению:", context.codingPath)
            return nil
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Тип '\(type)' не соответствует ожидаемому:", context.debugDescription)
            print("Путь к значению:", context.codingPath)
            return nil
        } catch {
            print(error.localizedDescription)
            print("Ошибка: ", error)
            return nil
        }
    }
}
