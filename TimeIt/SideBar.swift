//
//  SideBar.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

struct SideBar: View {
    @Binding var isSidebarVisible: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    
    @EnvironmentObject var recordManager: RecordManager
    
    var body: some View {
        ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color(UIColor.systemBackground.withAlphaComponent(0.1)))
                .opacity(isSidebarVisible ? 1 : 0)
                .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }
                content
            }
            .edgesIgnoringSafeArea(.all)
    }
    
    var content: some View {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    VStack {
                        NavigationView {
                            VStack {
                                Form {
                                    Section (header: Text("App Settings")){
                                        Button(action: {
                                            recordManager.resetProfileData()
                                        }) {
                                            Text("Clear all data")
                                        }.buttonStyle(.borderless)
                                    }
                                    Section(header: Text("ABOUT")) {
                                        HStack {
                                            Text("Version")
                                            Spacer()
                                            Text("0.0.1")
                                        }
                                    }
                                    
                                    Section(header: Text("Support")){
                                        HStack {
                                            Text("Buy me a coffee")
                                            Spacer()
                                            Button(action: {
                                                //recordManager.resetProfileData()
                                            }) {
                                                Text("Rs 140")
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 100)
                                
                                Text("@pseudocoder.in")
                                    .font(.caption2)
                            }
                            .background(Color(UIColor.systemGroupedBackground))
                        }
                        .navigationTitle("Settings")
                    }
                    MenuChevron
                }
                .frame(width: sideBarWidth)
                .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
                .animation(.default, value: isSidebarVisible)
                Spacer()
            }
        }
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(UIColor.systemBlue))
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: isSidebarVisible ? -18 : -10)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }

            Image(systemName: "chevron.right")
                .foregroundColor(.white)
                .rotationEffect(
                  isSidebarVisible ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: isSidebarVisible ? -4 : 8)
                .foregroundColor(.blue)
        }
        .offset(x: sideBarWidth / 2, y: 80)
        .animation(.default, value: isSidebarVisible)
    }
}


struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(isSidebarVisible:.constant(true))
    }
}
