//
//  sheetVIew.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import SwiftData
import CloudKit
import CoreData

struct sheetVIew: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State var newOffense = ""
    @Binding var isCopShowing: Bool
    var body: some View {
        ZStack{
            Image(.slothArmy)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                TextField("Enter Kiana's offense", text: $newOffense)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                   addOff()
                    dismiss()
                    withAnimation(.easeInOut(duration: 2)) {
                        isCopShowing.toggle()
                    }
                    
                }) {
                    Text("Offense taken note")
                    
                }
                .foregroundStyle(.white)
                .padding()
                .background(.black)
                .cornerRadius(50)
            }
        }
        
    }
    func addOff() {
       let newTask = Offense(context: viewContext)
        newTask.name = newOffense
        newTask.date = Date.now
        
        try? viewContext.save()
    }
}

//#Preview {
//
//}
