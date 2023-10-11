//
//  ContentView.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                vm.onLogin()
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
