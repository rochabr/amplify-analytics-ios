//
//  traveldealsApp.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-03-02.
//

import SwiftUI

import Amplify
import AmplifyPlugins

@main
struct traveldealsApp: App {
    @ObservedObject var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
            
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
                
            case .session(let user):
                SessionView(user: user)
                    .environmentObject(sessionManager)
            }
        }
    }

    init() {
        do{
            //Auth
            try Amplify.add(plugin:AWSCognitoAuthPlugin())

            //API
            //let models = AmplifyModels()
            try Amplify.add(plugin:AWSAPIPlugin(modelRegistration: AmplifyModels()))
            
            //configure plugins
            try Amplify.configure()
            print("Amplify succesfully configured")
        } catch {
            print("could not initialize amplify", error)
        }
        
        //gets current authenticated user
        sessionManager.getCurrentAuthUser()
    }
}
