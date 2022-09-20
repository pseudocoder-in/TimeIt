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
            VStack{
                ProfileDropDown()
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
                StopwatchInfoView(timeElapsed: $timeElapsed)
                Spacer()
            }
        }
}

struct StopwatchInfoView : View {
    @EnvironmentObject var recordManager: RecordManager
    @Binding<Float> var timeElapsed : Float
    var body : some View {
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
                .frame(alignment: .center)
                VStack{
                    Text("Current Time")
                        .font(.title3)
                    Text(printSecondsToHoursMinutesSeconds(Int(timeElapsed)))
                        .font(.body)
                        .padding()
                }
                .frame(alignment: .center)
            }
    }
}

struct ProfileDropDown : View {
    
    @EnvironmentObject var recordManager: RecordManager
    @State var selection: UUID = Profile.DefaultProfile.id
    
    var body : some View {
        Picker(recordManager.profiles[recordManager.activeProfileIndex].name, selection: $selection) {
            ForEach(recordManager.profiles, id: \.id) { profile in
                Text(profile.name).tag(profile.id)
            }
        }
        .onAppear(perform: {
            selection = recordManager.profiles[recordManager.activeProfileIndex].id
        })
        .pickerStyle(MenuPickerStyle())
        .onChange(of: selection) { tag in
            recordManager.setActivateProfileWithId(id: tag)
        }
       /* Menu(recordManager.profiles[recordManager.activeProfileIndex].name){
            ForEach(recordManager.profiles, id: \.id) { profile in
                Button(profile.name, action : {
                    recordManager.setActivateProfileWithId(id: profile.id)
                })
            }
        }*/
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
