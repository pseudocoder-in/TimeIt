//
//  TimerView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

struct TimerView: View {
    @State var timeElapsed : Float = 0
    @State var secondValue: Float = 0.0
    @State var minuteValue: Float = 0.0
    @State var hourValue: Float = 0.0
    @State var timerType : String = "StopWatch"
    @State private var isSidebarOpened = false
    
    @EnvironmentObject var recordManager: RecordManager
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                StopwatchView(timeElapsed: $timeElapsed)
                Spacer()
                Picker("Timer Type", selection: $timerType) {
                    Text("StopWatch")
                        .tag("StopWatch")
                    Text("CountDown")
                        .tag("CountDown")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
                HStack(spacing:0){
                    VStack{
                        Text("Last Time")
                            .foregroundColor(.secondary)
                            .font(.title3)
                        Text(printSecondsToHoursMinutesSeconds(Int(recordManager.profiles[recordManager.activeProfileIndex].records.isEmpty ? 0 : recordManager.profiles[recordManager.activeProfileIndex].records.last!.duration)))
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    .frame(width: geo.size.width * 0.5, alignment: .center)
                    VStack{
                        Text("Current Time")
                            .font(.title3)
                        Text(printSecondsToHoursMinutesSeconds(Int(timeElapsed)))
                            .font(.body)
                            .padding()
                    }
                    .frame(width: geo.size.width * 0.5, alignment: .center)
                }
                Spacer()
            }
        }
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String{
  let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
  return "\(h) Hr \(m) Min \(s) Sec"
}


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
