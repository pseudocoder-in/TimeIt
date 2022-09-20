//
//  ContentView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isSideBarOpened = false
    
    @StateObject var recordManager = RecordManager()
    @State private var selection = 2
    
    var body: some View {
        ZStack {
            TabView(selection:$selection) {
                ProfileView()
                    .environmentObject(recordManager)
                    .tabItem {
                        Label("Profiles", systemImage: "house.fill")
                    }
                    .tag(1)
                TimerView()
                    .environmentObject(recordManager)
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }
                    .tag(2)

                InsightView()
                    .environmentObject(recordManager)
                    .tabItem {
                        Label("Insight", systemImage: "chart.bar.xaxis")
                    }
                    .tag(3)
            }
            .opacity(isSideBarOpened ? 0.3 : 1)
            SideBar(isSidebarVisible: $isSideBarOpened)
                .environmentObject(recordManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
