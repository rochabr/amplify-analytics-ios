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
            
        }
    }
    
    
    func save(){
        
        let deal = Deal(
            name: name,
            category: categories[selectedCategory]
           // owner: Amplify.Auth.getCurrentUser()?.username
        )
        
        // 3
        _ = Amplify.API.mutate(request: .create(deal)) { event in
          switch event {
          // 4
          case .failure(let error):
            print("Failed to save entry ", error)
          case .success(let result):
            switch result {
            case .failure(let error):
                print("Failed to save entry ", error)
            case .success(let deal):
              // 5
                print("Saved deal: ", deal)
                self.showModal.toggle()
            }
          }
        }
        
//        Amplify.DataStore.save(deal){ result in
//            switch result {
//            case .success:
//                print("Saved entry")
//                self.showModal.toggle()
//            case .failure(let error):
//                print("Failed to save entry ", error)
//            }
//        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeal(showModal: .constant(true))
    }
}
