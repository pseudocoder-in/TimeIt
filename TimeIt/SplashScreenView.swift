//
//  SplashScreenView.swift
//  TimeIt
//
//  Created by Subhash on 22/09/22.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack{
                HStack(spacing:0){
                    Text("Time")
                        .font(.largeTitle)
                        .bold()
                    Text("It")
                        .font(.largeTitle)
                        .foregroundColor(Color.green)
                        .bold()
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
