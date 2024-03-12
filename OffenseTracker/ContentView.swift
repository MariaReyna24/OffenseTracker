//
//  ContentView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct ContentView: View {
    @Query var offense: [Offenses]
    @State var showingSheet = false
    @Environment(\.modelContext) var modelContext
    @State var isCopShowing = false
    @ObservedObject var sounds = SoundManager()
    var body: some View {
        if isCopShowing {
            Confirmation()
                .onAppear{
                    sounds.playSound()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5, execute: {
                        self.isCopShowing.toggle()
                    })
                }
        } else {
            ZStack {
                Image(.kingSloth)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    List {
                        ForEach(offense) { off in
                            Text("\(off.name) on \(off.date.formatted(date: .long, time: .shortened)) ")
                        } .onDelete(perform: delteOffense)
                    }
                    .padding()
                    .scrollContentBackground(.hidden)
                   
                    Button("Add offense") {
                        showingSheet.toggle()
                    }
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                    .padding(.all)
                    .padding()
                    .tint(.black)
                    .sheet(isPresented: $showingSheet){
                        sheetVIew(off: Offenses(), isCopShowing: $isCopShowing)
                            .presentationDetents([.fraction(0.20)])
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            
        }
    }
    func delteOffense(_ indexSet: IndexSet){
        for index in indexSet {
            let offense = offense[index]
            modelContext.delete(offense)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Offenses.self, configurations: config)
        //let example = Offenses(name: "Example Offense")
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
}
