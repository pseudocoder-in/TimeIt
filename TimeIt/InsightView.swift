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
    func getHeight(duration: Int) -> Int {
        let maxDuration:Int = recordManager.profiles[recordManager.activeProfileIndex].records.max { $0.duration < $1.duration }?.duration ?? 400
        if(maxDuration > 0){
            let relativeHeight = duration * maxHeight / maxDuration
            return relativeHeight
        }
        return 0;
    }
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView (.horizontal, showsIndicators: false) {
                GeometryReader { gp in
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom,
                                spacing: 1){
                            ForEach(recordManager.profiles[recordManager.activeProfileIndex].records, id: \.id){ record in
                                Bar(height: getHeight(duration: record.duration ),  durationInSec:record.duration,
                                    target: record.target).id(record.id)
                            }
                        }
                    }
                    .frame(height: gp.size.height)
                }
            }
            .onAppear(perform: {
                value.scrollTo(recordManager.profiles[recordManager.activeProfileIndex].records.last?.id)
            })
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
    
    var body: some View {
        return ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(UIColor.systemGreen))
                .frame(width: 20, height: CGFloat(self.height))
                .background(Color(UIColor.systemGreen))
                .cornerRadius(5)
            Text("\(durationInSec)")
                .font(.caption)
                .rotationEffect(.degrees(-90))
                .fixedSize()
                .frame(width: 20, height: 180, alignment: .bottom)
                .padding(.vertical)
            Line()
               .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                .frame(height: CGFloat(self.target))
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
