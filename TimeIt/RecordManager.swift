//
//  RecordManager.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import Foundation

struct Record {
    var id : UUID
    var duration : Int
    var date : Date
    
    static let example = Record(id:UUID(), duration:0, date:  Date.init())
}

class RecordManager : ObservableObject {
    @Published var records: [Record]
    
    init() {
        records = []
    }
    
    func addToRecord(seconds: Int){
        records.append(Record(id:UUID(), duration:seconds, date:  Date.init()))
    }
}
