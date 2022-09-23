//
//  ContentView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

class Screen: ObservableObject {
    @Published var keepScreenOn: Bool = false
}

struct ContentView: View {
    @State private var isSideBarOpened = false
    @StateObject var screen : Screen = Screen()
    @StateObject var recordManager = RecordManager()
    @State private var selection = 2
    
    var body: some View {
        ZStack {
            TabView(selection:$selection) {
                ProfileView()
                    .environmentObject(recordManager)
                    .environmentObject(screen)
                    .tabItem {
                        Label("Profiles", systemImage: "square.stack.3d.up.fill")
                    }
                    .tag(1)
                TimerView()
                    .environmentObject(recordManager)
                    .environmentObject(screen)
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
                .environmentObject(screen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
