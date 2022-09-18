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
        let maxDuration:Int = recordManager.records.max { $0.duration < $1.duration }?.duration ?? 400
        return duration * maxHeight / maxDuration;
    }
    var body: some View {
        ScrollViewReader { value in
            ScrollView (.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom,
                        spacing: 1){
                    ForEach(recordManager.records, id: \.id){ record in
                        Bar(height: getHeight(duration: record.duration)).id(record.id)
                    }
                }
            }
            .onAppear(perform: {
                value.scrollTo(recordManager.records.last?.id)
            })
        }
    }
}

struct Bar : View {
    @State var height: Int = 0
    
    var body: some View {
        Rectangle()
            .frame(width: 20, height: CGFloat(self.height))
            .background(Color(UIColor.secondaryLabel.withAlphaComponent(0.1)))
            .cornerRadius(5)
    }
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}
