//
//  ConfirmationView.swift
//  cp-amplify-demo
//
//  Created by Rocha Silva, Fernando on 2021-02-19.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        ZStack {
            Color.init(UIColor.placeholderText)
                .edgesIgnoringSafeArea(.all)
            VStack{
            Text("Username: \(username)")
            TextField("Confirmation Code", text: $confirmationCode).pretty()
            Button("Confirm", action: {
                sessionManager.confirm(
                    username: username,
                    code: confirmationCode
                )
            }).pretty()
        }
        .padding()
        }
    }
    
}


