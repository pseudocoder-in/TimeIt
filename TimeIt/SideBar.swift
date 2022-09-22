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
    
    @StateObject var purchaseManager: PurchaseManager = PurchaseManager()

    
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
            .onAppear(perform: {
                purchaseManager.fetchProduct()
            })
    }
    
    var content: some View {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                        NavigationView {
                            VStack {
                                Form {
                                    Section (header: Text("App Settings")){
                                        Button(action: {
                                            recordManager.resetProfileData()
                                        }) {
                                            Text("Clear all data")
                                        }.buttonStyle(.borderless)
                                        VStack(alignment: .leading, spacing:6){
                                            Button(action: {
                                                //recordManager.resetProfileData()
                                            }) {
                                                Text("Export profile data")
                                            }.buttonStyle(.borderless)
                                                .disabled(true)
                                            Text("Easily export your data to a local file and load it later in the app")
                                                .font(.caption)
                                                .foregroundColor(Color.secondary)
                                            Text("Coming in next release")
                                                .font(.caption)
                                        }
                                    }
                                    Section(header: Text("Support")){
                                        if(purchaseManager.purchasedIds.isEmpty){
                                            VStack(alignment: .leading, spacing:6) {
                                                HStack {
                                                        Text("Buy me a coffee")
                                                        Spacer()
                                                        Button(action: {
                                                            purchaseManager.purchase()
                                                                
                                                        }) {
                                                            Text("Rs 140")
                                                        }
                                                }
                                                Text("We need your support in maintaining this app and keep it listed in the appstore.")
                                                    .font(.caption)
                                                    .foregroundColor(Color.secondary)
                                                Text("All the features will always be free and wihtout any ads").font(.caption)
                                                    .foregroundColor(Color.primary)
                                            }
                                        } else {
                                            VStack(alignment: .leading, spacing:6) {
                                                HStack {
                                                    Text("Thanks for your tip")
                                                        .font(.callout)
                                                    Image(systemName: "heart.fill")
                                                }
                                                Text("This will help us in keeping this app active and free from any ads or from adding any feature behind a paywall. Thanks again.").font(.caption)
                                                    .foregroundColor(Color.secondary)
                                            }
                                        }
                                    }
                                    
                                    Section(header: Text("ABOUT")) {
                                        HStack {
                                            Text("Version").font(.caption)
                                            Spacer()
                                            Text("0.0.1").font(.caption)
                                        }
                                        
                                        HStack {
                                            Spacer()
                                            Link("Contact Us", destination: URL(string: "mailto:contact@pseudocoder.in")!)
                                                .font(.body)
                                            Spacer()
                                        }
                                    }
                                }.padding(.vertical, 80)
                                
                                Text("@pseudocoder.in")
                                    .font(.caption2)
                            }
                            .background(Color(UIColor.systemGroupedBackground))
                        }
                        .navigationTitle("Settings")
                    HStack(spacing:0) {
                        Text("Time")
                            .font(.title)
                            .bold()
                        .offset(y: 60)
                        Text("It")
                            .font(.title)
                            .foregroundColor(Color.green)
                            .bold()
                        .offset(y: 60)
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
