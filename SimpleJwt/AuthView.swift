//
//  AuthView.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: UserView(), isActive: $vm.success) {}
                Text("Simple Jwt")
                    .font(.largeTitle.weight(.bold))
                TextField("Логин", text: $vm.usernameText)
                    .padding()
                    .background(Color(red: 227/255, green: 227/255, blue: 227/255))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                SecureField("Пароль", text: $vm.passwordText)
                    .padding()
                    .background(Color(red: 227/255, green: 227/255, blue: 227/255))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                Button(action: {
                    vm.onLogin()
                }) {
                    Text("Войти")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
