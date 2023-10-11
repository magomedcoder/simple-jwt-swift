//
//  SimpleJwtApp.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

@main
struct SimpleJwtApp: App {
    @State var vm = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            vm.isAuth() ? AnyView(UserView()) : AnyView(AuthView())
        }
    }
}
