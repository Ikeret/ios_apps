//
//  HomeView.swift
//  Checker
//
//  Created by Сергей Коршунов on 25.07.2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            
            
            List {
                
                HStack {
                    TextField(/*@START_MENU_TOKEN@*/.constant("Placeholder")/*@END_MENU_TOKEN@*/)
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("Add")
                            .foregroundColor(.white)
                    }
                    .frame(width: 90, height: 30)
                        .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                        .cornerRadius(5)
                }.padding()
                
                ForEach(1...5) { item in
                    
                    HStack {
                        Text("Task \(item)")
                        Spacer()
                        Text("Complted")
                    }
                    
                }
            }
                
                .navigationBarTitle(Text("List Title"))
                
                .navigationBarItems(leading: Button(action: {}) {
                    Image(systemName: "list.bullet")
                    }, trailing:  HStack {
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                            
                        }
                        Spacer(minLength: Length(20.0))
                        Button(action: { }) {
                            Image(systemName: "plus")
                        }
                } )
            
        }
            
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
        }
        .tag(0)
        
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
