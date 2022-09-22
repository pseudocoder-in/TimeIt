//
//  ProfileView.swift
//  TimeIt
//
//  Created by Subhash on 19/09/22.
//

import SwiftUI

struct ProfileView: View {
    @State var isEditing = false
    
    @EnvironmentObject var recordManager: RecordManager

    
    var body: some View {
        NavigationView {
        ZStack{
            List{
                    ForEach(recordManager.profiles, id: \.id) { profile in
                        HStack {
                            //Image(systemName: workout.icon)
                            //    .padding(.horizontal)
                            Text(profile.name)
                        }
                        .deleteDisabled(profile.name == "Default")
                        .background( NavigationLink("", destination: DetailView(profileId: profile.id)).opacity(0) )
                    }
                    .onDelete{indexSet in
                        recordManager.removeProfile(atOffsets: indexSet)
                    }
                    .onMove{indexSet, index in
                        recordManager.moveProfile(fromOffsets: indexSet, toOffset: index)
                    }
            }
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    AddMenu()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.isEditing.toggle()
                }){
                    if self.isEditing {
                        Text("Done")
                    } else {
                        Image(systemName: "arrow.up.arrow.down").imageScale(.medium)
                    }
                }
            }
        )
        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
        .environmentObject(recordManager)
        .toolbar { // <2>
            ToolbarItem(placement: .principal) { // <3>
                VStack {
                    Text("Profiles").font(.headline)
                    Text("Create seperate profiles to track different activities")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    }
}

struct AddMenu : View {
    
    @State private var navigateTo: AnyView?
    @State private var isActive = false
    @State var showingAddProfileView = false
    @EnvironmentObject var recordManager: RecordManager
    
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .font(.largeTitle)
            .padding(40)
        .onTapGesture {
            showingAddProfileView = true
        }
        .popover(isPresented: $showingAddProfileView) {
            AddProfileView(showingAddProfileView : $showingAddProfileView)
                .environmentObject(recordManager)
        }
    }
}

struct AddProfileView : View {
    @Binding var showingAddProfileView : Bool
    @EnvironmentObject var recordManager: RecordManager
    @State private var name: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    @State private var showingAlert = false
        
    var body : some View {
        VStack {
            Spacer()
            ProfileFormView(name: $name, hours: $hours, minutes: $minutes, seconds: $seconds, nameDisabled : .constant(false))
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingAddProfileView = false
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    if(name == "Default"){
                        showingAlert = true
                    } else {
                        let newProfile = Profile(id:UUID(), name:name, records: [], target: hours * 3600 + minutes * 60 + seconds)
                        recordManager.addProfile(profile: newProfile)
                        recordManager.setActiveProfileWithId(id: newProfile.id)
                        showingAddProfileView = false
                    }
                }) {
                    Text("Save")
                }
                Spacer()
            }
            Spacer()
        }.padding()
        .alert("Invalid Name", isPresented: $showingAlert) {
            VStack {
                Text("Please select a different name.")
                Button("OK", role: .cancel) { }
            }
        }
    }
    
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: super.intrinsicContentSize.height)
    }
}

struct ProfileFormView : View {
    @Binding var name: String
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    @Binding var nameDisabled : Bool
    
    var body : some View {
        TextField("Name", text: $name)
            .padding()
            .background(Color(UIColor.secondaryLabel.withAlphaComponent(0.1)))
            .cornerRadius(10)
            .disabled(nameDisabled)
        
        Spacer()
        Text("Choose Target")
            .font(.body)
            HStack{
                Picker(selection: $hours, label: Text("Amount")){
                    ForEach(0...24, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                    }
                }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                    .compositingGroup()
                    .clipped()
                Text(":")
                Picker(selection: $minutes, label: Text("Type")){
                    ForEach(0...60, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                    }
                }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                    .compositingGroup()
                    .clipped()
                Text(":")
                Picker(selection: $seconds, label: Text("Occurance")){
                    ForEach(0...60, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                    }
                }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                    .compositingGroup()
                    .clipped()
            }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
