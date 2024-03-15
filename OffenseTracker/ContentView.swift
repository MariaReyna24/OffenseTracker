//
//  ContentView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import SwiftData
import AVFoundation
import CloudKit

struct ContentView: View {
    @Query var offense: [Offenses]
    @State var showingSheet = false
    @Environment(\.modelContext) var modelContext
    @State var isCopShowing = false
    @ObservedObject var sounds = SoundManager()
    @State var randomDouble = 0.0
    @State var randomPosition = CGPoint(x: 200, y: 400)
    @State var hideButton = false
    @State var bouncing = true
    var body: some View {
        if isCopShowing {
            Confirmation()
                .onAppear{
                    sounds.playSound()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        withAnimation(.easeOut(duration: 3)) {
                            self.isCopShowing.toggle()
                            randomDouble = Double.random(in: 0...360)
                            randomPosition = CGPoint(x: Double.random(in: 100...300), y: Double.random(in: 200...500))
                        }
                    })
                }
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                Image(.burningCty)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                Image(.loneSloth)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(randomDouble))
                    .position(randomPosition)
                    .onAppear{
                        withAnimation(.bouncy(duration: .infinity)){}
                    }
                VStack {
                    List {
                        ForEach(offense) { off in
                            Text("\(off.name ?? "Ex") on  \(off.date?.formatted(date: .long, time: .shortened) ?? "ex date"))")
                        } .onDelete(perform: delteOffense)
                    }
                    .padding()
                    .scrollContentBackground(.hidden)
                    //.listRowBackground(Color.white.opacity(0.1))
                    
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
