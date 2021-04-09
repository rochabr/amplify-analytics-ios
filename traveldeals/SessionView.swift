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
    
    @State private var showModal = false
    @State private var deals =  Array<Deal>()
    
    var xOffset: CGFloat = 50
    var yOffset: CGFloat = 50
    
    var colors = [Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.pink]
    
    let user: AuthUser
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button("Sign Out", action: sessionManager.signOut).padding()
            }
            Spacer()
            
            List(self.deals) { deal in
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text(deal.name)
                            .font(.system(size: 50))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 180,
                            maxHeight: 180,
                            alignment: .center
                    )
                    .background(colors.randomElement())
                    Text(deal.category)
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            
            Spacer()
            Button("Create new deal") {
                let event = BasicAnalyticsEvent(name: "createDeal-start")
                Amplify.Analytics.record(event: event)
                
                self.showModal.toggle()
            }
            .pretty()
            .sheet(isPresented: $showModal, content: {
                CreateDeal(showModal:$showModal, deals: $deals)
            })
            
        }.onAppear(){
            query()
        }
    }

    func query(){
        Amplify.DataStore.query(Deal.self) { result in
            switch result {
            case .success(let deals):
                print("Deals retrieved successfully: \(deals)")
                deals.forEach { deal in
                    //Amplify.DataStore.delete(deal)
                    self.deals.append(deal)
                }
                
            case .failure(let error):
                print("Error retrieving posts \(error)")
            }
        }
    }
}
