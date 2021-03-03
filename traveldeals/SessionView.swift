//
//  SessionView.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-02-19.
//

import Amplify
import SwiftUI

struct SessionView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        ZStack {
            Color.init(UIColor.placeholderText)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack{
                    Spacer()
                    Button("Sign Out", action: sessionManager.signOut).padding()
                }
                Spacer()
                Button("Create new deal", action: sessionManager.signOut).pretty()
            }
        }
    }

}