//
//  RecordManager.swift
//  TimeIt
//
//  Created by Subhash on 18/09/22.
//

import Foundation

struct Record : Codable {
    
    var id : UUID
    var duration : Int
    var date : Date
    var target: Int
    static let example = Record(id:UUID(), duration:0, date:  Date.init(), target: 40)
}

struct Profile : Codable {
    var id : UUID
    var name : String
    var records: [Record]
    var target: Int
    static let DefaultProfile = Profile(id:UUID(), name:"Default", records: [Record.example], target: 40)
}

struct ProfileData : Codable{
    var profiles: [Profile]
    var activeProfileId : UUID
}

class RecordManager : ObservableObject {
    @Published var profiles: [Profile]
    @Published var activeProfileIndex: Int
    @Published var activeProfileId : UUID
    
    init() {
        let profile = Profile(id:UUID(), name:"Default", records: [], target: 40)
        profiles = [profile]
        activeProfileIndex = 0
        activeProfileId = profile.id
        loadDataFromStorage()
        if(!self.profiles.isEmpty){
            activeProfileIndex = self.profiles.firstIndex { $0.id == activeProfileId } ?? 0
        }
    }
    
    func addToRecord(seconds: Int){
        profiles[activeProfileIndex].records.append(Record(id:UUID(), duration:seconds, date:  Date.init(), target: profiles[activeProfileIndex].target))
        saveDataToStorage()
    }

    func setActivateProfileWithId(id: UUID){
        if let offset = profiles.firstIndex(where: {$0.id == id}) {
            activeProfileIndex = offset
            activeProfileId = id
            saveDataToStorage()
        }
    }
    
    func modifyProfileWithId(id: UUID, name: String, target: Int) {
        let index = getIndexForId(id: id)
        profiles[index].name = name
        profiles[index].target = target
        saveDataToStorage()
    }
    
    func getIndexForId(id: UUID) -> Int {
        if let offset = profiles.firstIndex(where: {$0.id == id}) {
            return offset
        }
        // FIX THIS
        return 0
    }
    
    func addProfile(profile: Profile){
        profiles.append(profile)
        saveDataToStorage()
    }
    
    func removeProfile(atOffsets: IndexSet){
        profiles.remove(atOffsets: atOffsets)
        saveDataToStorage()
    }
    
    func moveProfile(fromOffsets: IndexSet, toOffset: Int){
        profiles.move(fromOffsets: fromOffsets, toOffset: toOffset)
        saveDataToStorage()
    }
    
    func saveDataToStorage(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(ProfileData(profiles: profiles, activeProfileId: activeProfileId)) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Profiles")
        }
    }
    
    func loadDataFromStorage(){
        let defaults = UserDefaults.standard;
        if let savedProfiles = defaults.object(forKey: "Profiles") as? Data {
            let decoder = JSONDecoder()
            if let pdata = try? decoder.decode(ProfileData.self, from: savedProfiles) {
                self.profiles = pdata.profiles
                self.activeProfileId = pdata.activeProfileId
            }
        }
    }
    
    func resetProfileData(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Profiles")
        let profile = Profile(id:UUID(), name:"Default", records: [], target: 40)
        profiles = [profile]
        activeProfileId = profile.id
        activeProfileIndex = 0
    }
}
