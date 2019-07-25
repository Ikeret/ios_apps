//
//  SettingsView.swift
//  Checker
//
//  Created by Сергей Коршунов on 25.07.2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text("Second View")
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tag(2)
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
