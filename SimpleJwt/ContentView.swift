//
//  ContentView.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk3MTM0MDg4LCJpYXQiOjE2OTcwMTQwODgsImp0aSI6ImExMzc1MThhYWNmNDQ2MzRiNWFmZWY2N2I0ZWNjMjAwIiwidXNlcl9pZCI6M30.Y7vFwlWjoCbUWTfQAwRKfVhhjekQ3SS7DEebkwujkGc"
  
        if let jwt = JWTDecode(token: token) {
            let payload = jwt.payload
            let expiresIn = payload.expiresIn
        } else {

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
