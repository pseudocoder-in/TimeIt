//
//  RecordManager.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import Foundation

struct Record : Codable{
    var id : UUID
    var duration : Int
    var date : Date
    var target: Int
    static let example = Record(id:UUID(), duration:0, date:  Date.init(), target: 40)
}

struct Profile : Codable{
    var id : UUID
    var name : String
    var records: [Record]
    var target: Int
    var isActive : Bool
    static let DefaultProfile = Profile(id:UUID(), name:"Default", records: [Record.example], target: 40, isActive: true)
}

class RecordManager : ObservableObject {
    @Published var profiles: [Profile]
    @Published var activeProfileIndex: Int
    
    init() {
        let profile = Profile(id:UUID(), name:"Default", records: [], target: 40, isActive: true)
        profiles = [profile]
        activeProfileIndex = 0
        loadDataFromStorage()
        if(!self.profiles.isEmpty){
            activeProfileIndex = self.profiles.firstIndex { $0.isActive == true } ?? 0
        }
    }
    
    func addToRecord(seconds: Int){
        profiles[activeProfileIndex].records.append(Record(id:UUID(), duration:seconds, date:  Date.init(), target: profiles[activeProfileIndex].target))
        // SaveToLocalStore()
        saveDataToStorage()
    }
    
    func setActivateProfileIndex(atOffsets: Int){
        //check if it passes by reference as we need reference
        activeProfileIndex = activeProfileIndex
    }
    
    func addProfile(profile: Profile){
        profiles.append(profile)
        // SaveToLocalStore()
    }
    
    func removeProfile(atOffsets: IndexSet){
        profiles.remove(atOffsets: atOffsets)
        // SaveToLocalStore()
    }
    
    func moveProfile(fromOffsets: IndexSet, toOffset: Int){
        profiles.move(fromOffsets: fromOffsets, toOffset: toOffset)
        // SaveToLocalStore()
    }
    
    func saveDataToStorage(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Profiles")
        }
    }
    
    func loadDataFromStorage(){
        let defaults = UserDefaults.standard;
        if let savedProfiles = defaults.object(forKey: "Profiles") as? Data {
            let decoder = JSONDecoder()
            if let profiles = try? decoder.decode([Profile].self, from: savedProfiles) {
                if(!profiles.isEmpty && !profiles[0].records.isEmpty){
                    print(profiles[0].records[0].duration)
                }
                self.profiles = profiles
            }
        }
    }
}
