
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
import CoreData

struct ContentView: View {
    @State var deletedIndex: IndexSet?
    @State private var forgive = false
    @State var showingSheet = false
    @State var isCopShowing = false
    @State private var isAlertShowing = false
    @ObservedObject var sounds = SoundManager()
    @State var randomDouble = 180.0
    @State var randomPosition = CGPoint(x: 200, y: 400)
    @Environment(\.managedObjectContext) private var viewContext
    @State private var bounce = false
    @ObservedObject var offVM = Offenses()
    @State private var ifYouSaySo = false
    @State private var isShowingDog = false
    var body: some View {
        if isCopShowing {
            Confirmation()
                .onAppear {
                    sounds.playSound(sound: .sus)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                        withAnimation(.easeOut(duration: 4)) {
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
            switch offVM.appState {
            case .loading:
                ProgressView()
                Text("Loading Kiana's Offenses...")
                    .font(.largeTitle)
                    .task {
                        try? await offVM.fetchOffenses()
                    }
            case .loaded:
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
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(0.2)) {
                                bounce.toggle()
                            }
                        }
                    VStack {
                        Spacer()
                        List {
                            ForEach(offVM.listOfOffenses) { off in
                                Text("\(off.name), Reported on \(off.date.formatted()))")
                                Button{
                                    
                                } label: {
                                    Text("\(off.emojis),\(off.count)")
                                }
                               
                            } .onDelete { index in
                                deletedIndex = index
                                isAlertShowing.toggle()
                            }
                            
                            .alert("Are you sure you want to forgive Kiana?", isPresented: $isAlertShowing) {
                                Button("Yes", role: .destructive) {
                                    isShowingDog.toggle()
                                }
                            }
                            .alert("Ok if you say so 😬" , isPresented: $ifYouSaySo) {
                                Button("Forgive", role: .destructive){
                                    deleteOff(indes: deletedIndex ?? IndexSet(integer: Int(1)))
                                    forgive.toggle()
                                }
                            }
                            
                            
                        }
                        .scrollContentBackground(.hidden)
                        .padding()
                        .refreshable {
                            try? await offVM.fetchOffenses()
                        }
                        .task {
                            try? await offVM.fetchOffenses()
                        }
                        
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
                            AddOffense(offVm: offVM, isCopShowing: $isCopShowing)
                                .presentationDetents([.fraction(offVM.addedImage ? 0.55: 0.40)])
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
                }.onAppear {
                    offVM.requestNotifPermission()
                }
            case .failed(let error):
                Text("Something bad happened oops: \(error.localizedDescription)")
            }
            
        }
    }
    func deleteOff(indes: IndexSet){
        for index in indes {
            let offense = offVM.listOfOffenses[index]
            print(offense)
            Task {
                try await offVM.delete(offense)
            }
        }
    }
}

#Preview {
    ContentView()
}
