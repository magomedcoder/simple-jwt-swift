//
//  UserView.swift
//  SimpleJwt
//
//  Created by Magomedcoder on 11.10.2023.
//

import SwiftUI

struct UserView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack {
            Text("Test")
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
