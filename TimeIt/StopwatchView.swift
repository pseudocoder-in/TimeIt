//
//  StopwatchView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI
import AVFoundation

let timerStep = 0.01
let timer = Timer.publish(every: timerStep, on: .main, in: .common).autoconnect()

struct StopwatchView: View {
    @Binding var timeElapsed:Float
    @Binding var timerType:TimerType
    
    @State var target: Int = 20
    
    @State var mSecondValue: Float = 0.0
    @State var secondValue: Float = 0.0
    @State var minuteValue: Float = 0.0
    @State var hourValue: Float = 0.0
    
    @State var firstTime = true;
    
    
    @EnvironmentObject var recordManager: RecordManager
    
    @State var isTimerRunning = false

    var body: some View {
        self.view
            .onAppear(perform: {
                target = recordManager.getActiveProfile().target;
            })
    }

    @ViewBuilder var view: some View {
        if(timerType == TimerType.classic){
            ClassicTimer
        } else {
            ModernTimer
        }
    }
    
    func checkAndPlaySound(){
        if(Int(timeElapsed) == target && firstTime){
            AudioServicesPlaySystemSound(SystemSoundID(1054))
            firstTime = false
        }
    }
    
    var ClassicTimer: some View {
        VStack{
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
                                    timeElapsed += Float(timerStep)
                                    checkAndPlaySound()
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
                //.background(Color(UIColor.secondaryLabel.withAlphaComponent(0.5)))
                .cornerRadius(150)
                .contentShape(Circle())
                .onTapGesture {
                    if(isTimerRunning){
                        recordManager.addToRecord(seconds: Int(timeElapsed))
                    }
                    firstTime = true
                    timeElapsed = 0
                    isTimerRunning.toggle()
                }
            }
            Text("\(String(format: "%02d", Int(hourValue * 12))):\(String(format: "%02d", Int(minuteValue * 60))):\(String(format: "%02d", Int(secondValue * 60))):\(String(format: "%02d", Int(mSecondValue))) ")
                .bold()
                .padding()
                .foregroundColor(isTimerRunning ? Color.green : Color.primary)
        }
    }
    
    var ModernTimer: some View {
        VStack{
            ZStack {
                ModernProgressBar(isTimerRunning: self.$isTimerRunning, color: Color(UIColor.systemYellow))
                    .frame(width: 240.0, height: 240.0)
                
                
                Text("\(isTimerRunning ? "STOP" : "START")")
                    .font(.title).bold()
                            .onReceive(timer) { _ in
                                if self.isTimerRunning {
                                    timeElapsed += Float(timerStep)
                                    checkAndPlaySound()
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
                .frame(width: 180, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(180)
                .contentShape(Circle())
                .onTapGesture {
                    if(isTimerRunning){
                        recordManager.addToRecord(seconds: Int(timeElapsed))
                    }
                    firstTime = true
                    timeElapsed = 0
                    isTimerRunning.toggle()
                }
            }
            Text("\(String(format: "%02d", Int(hourValue * 12))):\(String(format: "%02d", Int(minuteValue * 60))):\(String(format: "%02d", Int(secondValue * 60))):\(String(format: "%02d", Int(mSecondValue))) ")
                .bold()
                .padding()
                .foregroundColor(isTimerRunning ? Color.green : Color.primary)
        }
    }
}


struct ModernProgressBar: View {
    @Binding var isTimerRunning: Bool
    @State var color: Color
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        }
    
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [Color.blue, Color(UIColor.systemBackground)]),
        center: .center,
        startAngle: .degrees(270),
        endAngle: .degrees(0))
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(0.8))
                .stroke(gradient, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .overlay(
                    Circle().trim(from: 0, to: CGFloat(0.8))
                    .rotation(Angle.degrees(-4))
                    .stroke(gradient, style: StrokeStyle(lineWidth: 15, lineCap: .butt)))
                    .rotationEffect(Angle(degrees: isTimerRunning ? 360 : 0))
                    .animation(isTimerRunning ? foreverAnimation : .default, value: isTimerRunning)
             
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
                .animation(Animation.linear, value:self.progress)
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(timeElapsed: .constant(0), timerType: .constant(TimerType.modern), target: 10)
    }
}
