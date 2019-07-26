//
//  DailyView.swift
//  Checker
//
//  Created by Сергей Коршунов on 25.07.2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import SwiftUI

struct DailyView: View {
    var body: some View {
        Text("First View")
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("Daily List")
                }
        }
        .tag(1)
    }
}

#if DEBUG
struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
#endif
