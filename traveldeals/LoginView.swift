//
//  LoginView.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-02-19.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            Color.init(UIColor.placeholderText)
                .edgesIgnoringSafeArea(.all)
            VStack{
            Spacer()
            
            TextField("Username", text: $username).pretty()
            SecureField("Password", text: $password).pretty()
            Button("Login", action: {
                sessionManager.login(
                    username: username,
                    password: password
                )
                
            }).pretty()
            
            Spacer()
            Button("Don't have an account? Sign up.", action: sessionManager.showSignUp).pretty()
        }
        .padding()
        }
    }
}


