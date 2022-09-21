//
//  TimerView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

enum TimerType : Int, Codable{
    case classic, modern
}

struct TimerView: View {
    @State var timeElapsed : Float = 0
    @State var secondValue: Float = 0.0
    @State var minuteValue: Float = 0.0
    @State var hourValue: Float = 0.0
    @State var timerType : TimerType = TimerType.modern
    
    @EnvironmentObject var recordManager: RecordManager
    
    var body: some View {
            VStack{
                ProfileDropDown()
                Spacer()
                StopwatchView(timeElapsed: $timeElapsed, timerType: $timerType)
                Spacer()
                Picker("Timer Type", selection: $timerType) {
                    Text("Classic")
                        .tag(TimerType.classic)
                    Text("Modern")
                        .tag(TimerType.modern)
                }
                .onAppear(perform: {
                    timerType = recordManager.timerType
                })
                .onChange(of: timerType) { tag in
                    recordManager.setTimerType(type: tag)
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
            HStack(){
                Spacer()
                VStack(alignment: .center, spacing: 2){
                    Text("Last Time")
                        .foregroundColor(.secondary)
                        .font(.body)
                    Text(printSecondsToHoursMinutesSeconds(Int(recordManager.getActiveProfile().records.isEmpty ? 0 : recordManager.getActiveProfile().records.last!.duration)))
                        .font(.title3).bold()
                        .foregroundColor(.secondary).padding(.vertical)
                }
                Spacer()
                Divider()
                Spacer()
                VStack(alignment: .center, spacing: 2){
                    Text("Current Time")
                        .font(.body)
                    Text(printSecondsToHoursMinutesSeconds(Int(timeElapsed)))
                        .font(.title3).bold().padding(.vertical)
                }
                Spacer()
            }.frame(height: 100)
    }
}

struct ProfileDropDown : View {
    
    @EnvironmentObject var recordManager: RecordManager
    @State var selection: UUID = Profile.DefaultProfile.id
    
    var body : some View {
        Picker(recordManager.getActiveProfile().name, selection: $selection) {
            ForEach(recordManager.profiles, id: \.id) { profile in
                Text(profile.name).tag(profile.id)
            }
        }
        .onAppear(perform: {
            selection = recordManager.getActiveProfile().id
        })
        .pickerStyle(MenuPickerStyle())
        .onChange(of: selection) { tag in
            recordManager.setActiveProfileWithId(id: tag)
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
