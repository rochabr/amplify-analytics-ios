//
//  CreateDeal.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-03-03.
//

import SwiftUI
import Amplify

struct CreateDeal: View {
    
    var colors = [Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.pink]
    var categories = ["Outdoors", "Cities"]
    
    @State private var selectedCategory = 0
    
    @Binding var showModal: Bool
    @Binding var deals: Array<Deal>
    
    @State var name = ""
    @State var category = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("Category")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 20))
            Picker(selection: $selectedCategory, label: Text("Category")) {
                ForEach(0 ..< categories.count) {
                   Text(self.categories[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Deal name", text: $name).pretty()
                .padding()
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Text(name)
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                Spacer()
            }
            .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )
            .background(colors.randomElement())
            .padding()
            
            Spacer()

            HStack{
                Button("Cancel") {
                    self.showModal.toggle()
                }.pretty()

                Button("Save", action: {
                    save()
                }).pretty()
            }
        }.onAppear(){
            recordEvent()
        }
    }
    
    func recordEvent() {
//        let properties: AnalyticsProperties = [
//            "eventPropertyStringKey": "createDeal-start"
//        ]
        let event = BasicAnalyticsEvent(name: "createDeal-start")
        Amplify.Analytics.record(event: event)
    }
    
    func save(){
        
        let deal = Deal(
            name: name,
            category: categories[selectedCategory]
        )
        
        Amplify.DataStore.save(deal) {
            switch $0 {
            case .success(let deal):
                print("Added post with id: \(deal.id)")
                deals.append(deal)
                self.showModal.toggle()
            case .failure(let error):
                print("Error adding deal with Error: \(error.localizedDescription)")
            }
        }
    }
}

