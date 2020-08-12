//
//  ContentView.swift
//  coredatademo
//
//  Created by David Bates on 8/4/20.
//  Copyright © 2020 David Bates. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State var showingChildView = false
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.age, ascending: true)
        ]
    ) var people: FetchedResults<Person>
    @Environment(\.managedObjectContext) var managedObjectContext
   
    var body: some View {
        NavigationView{
            
            VStack{
                NavigationLink(destination: AddPeopleView(),
                               isActive: self.$showingChildView)
                { EmptyView() }
                    .frame(width: 0, height: 0)
                    .disabled(true)
            Text("People").font(Font.headline)
            List{
            ForEach(people, id: \.self){ person in
                NavigationLink(destination: Text(person.name ?? "Unknown")){
                        Text(person.name ?? "Unknown")
                    }
                }.onDelete(perform: delete)
            }.navigationBarItems(leading:Button(action:{ self.showingChildView = true }) { Text("Add") })
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
