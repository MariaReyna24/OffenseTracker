//
//  sheetVIew.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import SwiftData

struct sheetVIew: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var off: Offenses
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
                    modelContext.insert(Offenses(name: newOffense,date: Date.now))
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
    func addSamples() {
        let mean = Offenses(name:"Shes mean")
        let shake = Offenses(name: "She burnt my shake")
        let money = Offenses(name: "money money")
        
        modelContext.insert(mean)
        modelContext.insert(shake)
        modelContext.insert(money)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Offenses.self, configurations: config)
        let example = Offenses(name: "Example Offense")
        return sheetVIew(off: example, isCopShowing: .constant(false))
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
}
