//
//  ContentView.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

func JWTTest(token: String){
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

struct ContentView: View {
    
    var body: some View {
        VStack {
            let _: () = JWTTest(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk3MTM0MDg4LCJpYXQiOjE2OTcwMTQwODgsImp0aSI6ImExMzc1MThhYWNmNDQ2MzRiNWFmZWY2N2I0ZWNjMjAwIiwidXNlcl9pZCI6M30.Y7vFwlWjoCbUWTfQAwRKfVhhjekQ3SS7DEebkwujkGc")
            
            Text("Test")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
