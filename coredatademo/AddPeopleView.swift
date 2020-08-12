//
//  editpeople.swift
//  coredatademo
//
//  Created by David Bates on 8/10/20.
//  Copyright © 2020 David Bates. All rights reserved.
//

import SwiftUI

struct AddPeopleView: View {
// https://stackoverflow.com/questions/56513568/ios-swiftui-pop-or-dismiss-view-programmatically Used to dismiss view.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var name: String = ""
    @State private var age: Double = 10
    var genders = ["Unspecified", "Male", "Female", "NonBinary"]
    @State private var selectedGender = 0
    var body: some View {
        VStack{
        TextField("Enter your name", text: $name)
        Slider(value: $age, in: 10...90, step: 1.0)
        Text(String(age))
        Picker(selection: $selectedGender, label: Text("Please choose a gender")) {
           ForEach(0 ..< genders.count) {
              Text(self.genders[$0])
           }
        }
        Button(action: {
            let person = Person(context: self.managedObjectContext)
            person.name = self.name
            person.age = Int64(Int(self.age))
            person.gender = self.genders[self.selectedGender]
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
            }
            self.hideKeyboard()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Insert Person")
        }
        }
    }
}

struct AddPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        AddPeopleView()
    }
}
