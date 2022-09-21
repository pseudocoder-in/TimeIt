//
//  DetailView.swift
//  TimeIt
//
//  Created by Subhash on 19/09/22.
//

import SwiftUI

struct DetailView: View {
    @State var profileId : UUID;
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var recordManager: RecordManager
    @State private var name: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var nameDisabled: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            ProfileFormView(name: $name, hours: $hours, minutes: $minutes, seconds: $seconds, nameDisabled: $nameDisabled)
            Spacer()
            HStack(){
                Spacer()
                Button(action : { self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action : {
                        // save the modification
                    recordManager.modifyProfileWithId(id: profileId, name: name, target: hours * 3600 + minutes * 60 + seconds)
                        self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
                Spacer()
            }.padding()
        }
        .padding()
        .onAppear(perform: {
            // Get profileindex using profileID
            let profileIndex = recordManager.getIndexForId(id: profileId)
            let profile = recordManager.profiles[profileIndex]
            
            // Set all the props with value
            name = profile.name
            let timeInSeconds = profile.target
            let (h, m, s) = secondsToHoursMinutesSeconds(timeInSeconds)
            hours = h
            minutes = m
            seconds = s
            nameDisabled = name == "Default"
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(profileId: Profile.DefaultProfile.id)
    }
}
