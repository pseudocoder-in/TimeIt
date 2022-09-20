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
        let maxDuration:Int = recordManager.profiles[recordManager.activeProfileIndex].records.max { $0.duration < $1.duration }?.duration ?? 400
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
            ScrollViewReader { value in
                ScrollView (.horizontal, showsIndicators: false) {
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom,
                                spacing: 1){
                            ForEach(recordManager.profiles[recordManager.activeProfileIndex].records, id: \.id){ record in
                                Bar(height: getHeights(duration: record.duration, target: record.target).0,  durationInSec:record.duration,
                                    target: getHeights(duration: record.duration, target: record.target).1).id(record.id)
                            }
                        }
                    }
                }
                .onAppear(perform: {
                    value.scrollTo(recordManager.profiles[recordManager.activeProfileIndex].records.last?.id)
                })
            }
        }
    }
}

func printSecondsToHoursMinutesSeconds1(_ seconds: Int) -> String{
  let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
  return "\(h):\(m):\(s)"
}


struct Bar : View {
    var height: Int
    var durationInSec: Int
    var target: Int
    var maxHeight = 400.0
    
    var body: some View {
        return ZStack(alignment: .bottom) {
            Rectangle()
                .fill(self.height >= self.target ? Color(UIColor.systemGreen) : Color(UIColor.systemRed))
                .frame(width: 20, height: CGFloat(self.height))
                .background(self.height >= self.target ? Color(UIColor.systemGreen) : Color(UIColor.systemRed))
                .cornerRadius(5)
            Text("\(durationInSec)")
                .font(.caption)
                .rotationEffect(.degrees(-90))
                .fixedSize()
                .frame(width: 20, height: 180, alignment: .bottom)
                .padding(.vertical)
            Line()
                .stroke(style: StrokeStyle(lineWidth: self.target > Int(maxHeight) ? 0 : 1, dash: [2]))
                .frame(height: min(CGFloat(self.target), CGFloat(maxHeight)))
        }
    }
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
    static var previews: some View {
        InsightView()
    }
}
