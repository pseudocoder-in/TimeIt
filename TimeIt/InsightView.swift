//
//  InsightView.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import SwiftUI

struct InsightView: View {
    @EnvironmentObject var recordManager: RecordManager
    @State var maxHeight:Int = 400
    func getHeights(duration: Int, target: Int) -> (Int, Int) {
        let maxDuration:Int = recordManager.getActiveProfile().records.max { $0.duration < $1.duration }?.duration ?? maxHeight
        if(maxDuration > 0){
            let relativeHeight = duration * maxHeight / maxDuration
            let relativeTarget = target * maxHeight / maxDuration
            return (relativeHeight, relativeTarget)
        }
        return (0,0);
    }
    
    var body: some View {
        VStack {
            ProfileDropDown()
            Spacer()
            VStack{
                Text("Best")
                    .font(.title2)
                Text(printSecondsToHoursMinutesSeconds1(getMaxDuration(records: recordManager.getActiveProfile().records)))
                    .font(.title).bold()
                HStack{
                    Text("Target")
                        .font(.body)
                    Text(printSecondsToHoursMinutesSeconds1(recordManager.getActiveProfile().target))
                        .font(.body)
                }
                .foregroundColor(Color.secondary)
            }
            Spacer()
            ScrollView (.horizontal, showsIndicators: false) {
                ScrollViewReader { value in
                    HStack(alignment: .bottom,
                            spacing: 1){
                        ForEach(recordManager.getActiveProfile().records, id: \.id){ record in
                            Bar(height: getHeights(duration: record.duration, target: record.target).0,  durationInSec:record.duration,
                                target: getHeights(duration: record.duration, target: record.target).1, maxHeight: maxHeight).id(record.id)
                        }
                    }
                    .onAppear(perform: {
                        value.scrollTo(recordManager.getActiveProfile().records.last?.id)
                    })
                }
            }.padding(.vertical)
        }
    }
}

func getMaxDuration(records: [Record]) -> Int {
    if(records.isEmpty){
        return 0
    }
    return records.max { $0.duration < $1.duration }?.duration ?? 0
}

func printSecondsToHoursMinutesSeconds1(_ seconds: Int) -> String{
  let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
   return "\(String(format: "%02d", Int(h))):\(String(format: "%02d", Int(m))):\(String(format: "%02d", Int(s)))"
  //return "\(h):\(m):\(s)"
}

func getBarColor(height: Int, target: Int) -> Color {
    if(height >= Int(Double(target) * 0.8) && height < target) {
        return Color.yellow
    }
    return height >= target ? Color.green : Color.red
}

struct Bar : View {
    var height: Int
    var durationInSec: Int
    var target: Int
    var maxHeight :Int
    
    var body: some View {
        return ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(getBarColor(height: height, target: target))
                .frame(width: 20, height: CGFloat(self.height))
                .opacity(0.9)
                .cornerRadius(5)
            Text("\(getTimeValueFormatted(durationInSec: durationInSec))")
                .font(.caption)
                .rotated()
                .padding(.vertical, 5)
            Line()
                .stroke(style: StrokeStyle(lineWidth: self.target > Int(maxHeight) ? 0 : 1, dash: [2]))
                .frame(height: min(CGFloat(self.target), CGFloat(maxHeight)))
        }
    }
}

func getTimeValueFormatted(durationInSec: Int) -> String {
    let (h, m, s) = secondsToHoursMinutesSeconds(durationInSec)
    if(h > 0){
        return "\(h) Hr \(m) Min \(s) Sec"
    }
    if(m > 0) {
        return "\(m) Min \(s) Sec"
    }
    if( s > 0) {
        return "\(s) Sec"
    }
    return ""
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct InsightView_Previews: PreviewProvider {
    static var recordManager: RecordManager = RecordManager()
    init(){
        InsightView_Previews.recordManager.profiles = [Profile.ExampleProfile]
    }
    static var previews: some View {
        InsightView()
            .environmentObject(recordManager)
    }
}
