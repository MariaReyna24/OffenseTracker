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
import CoreHaptics

struct ContentView: View {
    @ObservedObject var sounds = SoundManager()
    // @Enviroment will access the model container to add the opjects to SwiftData
    @Environment(\.modelContext) var modelContext
    /*
     - All swift data models automatically confirm to the Identifiable protocol
     
     @Query will load all the data we set to it when the view appears
     but it will also watch the data base for changes so that
     whenever any data chanages the property will update
    */
    @Query var offense: [Offenses]
    @State var deletedIndex: IndexSet?
    @State var randomDouble = 180.0
    @State var randomPosition = CGPoint(x: 200, y: 400)
    @State private var showingSheet = false
    @State private var isCopShowing = false
    @State private var bounce = false
    @State private var isAlertShowing = false
    @State private var forgive = false
    @State private var ifYouSaySo = false
    @State private var isShowingDog = false
    var body: some View {
        if isCopShowing {
            Confirmation()
                .onAppear {
                    sounds.playSound(sound: .sus)
                    //heavyHaptic()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        withAnimation(.easeOut(duration: 3)) {
                            self.isCopShowing.toggle()
                            randomDouble = Double.random(in: 0...360)
                            randomPosition = CGPoint(x: Double.random(in: 100...300), y: Double.random(in: 200...500))
                        }
                    })
                }
        } else if forgive {
            Forgiveness()
                .transition(.move(edge: .top).combined(with: .push(from: .bottom)))
                .onAppear {
                    sounds.playSound(sound: .angels)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        withAnimation(.easeIn(duration: 2)){
                            self.forgive.toggle()
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
                // I stole this code from alex
                    .offset(y: bounce ? -20 :150)
                    .onAppear() {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            bounce.toggle()
                        }
                    }
                VStack {
                    List {
                        ForEach(offense) { off in
                            Text("\(off.name ?? "Ex") on \(off.date?.formatted(date: .long, time: .shortened) ?? "ex date")")
                                .foregroundStyle(.black)
                                .listRowBackground(Color.white.opacity(0.8))
                        } .onDelete { index in
                            deletedIndex = index
                            isAlertShowing.toggle()
                        }.alert("Are you sure you want to forgive Kiana?", isPresented: $isAlertShowing) {
                            Button("Yes", role: .destructive) {
                                isShowingDog.toggle()
                            }
                        }
                        .alert("Ok if you say so 😬" , isPresented: $ifYouSaySo) {
                            Button("Forgive", role: .destructive){
                                delteOffense(deletedIndex ?? IndexSet(integer: (1)))
                                forgive.toggle()
                            }
                        }
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
                }.overlay{
                    if isShowingDog {
                        SusDog()
                            .frame(width: 200,height: 150)
                            .onAppear{
                                sounds.playSound(sound: .bam)
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                    isShowingDog.toggle()
                                    ifYouSaySo.toggle()
                                })
                            }
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
// in order to preview the simulator you need to create a model container by hand because swift data doesnt know where to store the preview Data.
#Preview {
    do {
        // Makes a Configs the model to be stored inMemory
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        //creates that container we are using for this preview
        let container = try ModelContainer(for: Offenses.self, configurations: config)
        // this is an example to fill in the code but we dont need it cuz our content view doesnt take an ex data it only displays that data.
        let example = Offenses(name: "Example Offense")
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
}
