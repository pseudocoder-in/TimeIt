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
    var body: some View {
        ZStack {
            TabView {
                TimerView()
                    .environmentObject(recordManager)
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }

                InsightView()
                    .environmentObject(recordManager)
                    .tabItem {
                        Label("Insight", systemImage: "chart.bar.xaxis")
                    }
            }
            .blur(radius: isSideBarOpened ? 3.0 : 0)
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
