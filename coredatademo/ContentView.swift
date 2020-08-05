//
//  ContentView.swift
//  coredatademo
//
//  Created by David Bates on 8/4/20.
//  Copyright © 2020 David Bates. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.age, ascending: true)
        ]
    ) var people: FetchedResults<Person>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name: String = ""
    @State private var age: Double = 10
    var genders = ["Unspecified", "Male", "Female", "NonBinary"]
    @State private var selectedGender = 0
    var body: some View {
        VStack{
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
            }) {
                Text("Insert Person")
            }
                Divider()
            }
            VStack{
                Text("People").font(Font.headline)
            NavigationView{
                List{
                    ForEach(people, id: \.self){ person in
                Text(person.name ?? "Unknown")
                    }.onDelete(perform: delete)
                    
                }.navigationBarItems(trailing: EditButton())
            }
            }
        }
        
    }
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let person = people[index]
            managedObjectContext.delete(person)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
