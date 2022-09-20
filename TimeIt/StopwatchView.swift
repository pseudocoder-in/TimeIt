//
//  StopwatchView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

struct StopwatchView: View {
    @Binding var timeElapsed:Float
    
    @State var mSecondValue: Float = 0.0
    @State var secondValue: Float = 0.0
    @State var minuteValue: Float = 0.0
    @State var hourValue: Float = 0.0
    
    
    @EnvironmentObject var recordManager: RecordManager
    
    @State var isTimerRunning = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ZStack {
                ProgressBar(progress: self.$secondValue, color: Color(UIColor.systemYellow))
                    .frame(width: 240.0, height: 240.0)
                ProgressBar(progress: self.$minuteValue, color: Color(UIColor.systemGreen))
                    .frame(width: 210.0, height: 210.0)
                ProgressBar(progress: self.$hourValue, color: Color(UIColor.systemPurple))
                    .frame(width: 180.0, height: 180.0)
                
                
                Text("\(isTimerRunning ? "STOP" : "START")")
                    .font(.title).bold()
                            .onReceive(timer) { _ in
                                if self.isTimerRunning {
                                    timeElapsed += 0.1
                                    hourValue = Float(timeElapsed / 3600) / 12
                                    minuteValue = (timeElapsed.truncatingRemainder(dividingBy: 3600)) / 60 / 60
                                    secondValue = Float((timeElapsed.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)) / 60
                                    mSecondValue = (secondValue * 60 ).truncatingRemainder(dividingBy: 1) * 100
                                } else {
                                    hourValue = 0.0
                                    minuteValue = 0.0
                                    secondValue = 0.0
                                    mSecondValue = 0.0
                                }
                }
                .padding()
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(UIColor.secondaryLabel.withAlphaComponent(0.5)))
                .cornerRadius(150)
                .onTapGesture {
                    if(isTimerRunning){
                        recordManager.addToRecord(seconds: Int(timeElapsed))
                    }
                    timeElapsed = 0
                    isTimerRunning.toggle()
                }
            }
            Text("\(String(format: "%02d", Int(hourValue * 12))):\(String(format: "%02d", Int(minuteValue * 60))):\(String(format: "%02d", Int(secondValue * 60))):\(String(format: "%02d", Int(mSecondValue))) ").padding()
        }
    }
}



struct ProgressBar: View {
    @Binding var progress: Float
    @State var color: Color
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15.0)
                .opacity(0.3)
                .foregroundColor(color)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .shadow(color: Color(UIColor.label), radius: 1)
                .animation(Animation.linear)
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(timeElapsed: .constant(0))
    }
}
