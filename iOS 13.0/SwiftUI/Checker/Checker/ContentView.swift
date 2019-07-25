//
//  ContentView.swift
//  Checker
//
//  Created by Сергей Коршунов on 25/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        TabbedView(selection: $selection){
            DailyView()
            HomeView()
            SettingsView()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

