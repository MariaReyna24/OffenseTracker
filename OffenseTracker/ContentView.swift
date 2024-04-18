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
    //    @FetchRequest(sortDescriptors: []) private var offs: FetchedResults<Offense>
    @StateObject var offVM = Offenses()
    @State private var ifYouSaySo = false
    @State private var isShowingDog = false
    var body: some View {
        if isCopShowing {
            Confirmation()
                .onAppear {
                    sounds.playSound(sound: .sus)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                        withAnimation(.easeOut(duration: 5)) {
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
                List {
                    VStack {
                        switch offVM.appState {
                        case .loading:
                            VStack {
                                ProgressView()
                                Text("Nothing to see here..")
                            }
                            .listRowBackground(EmptyView())
                        case .loaded:
                            
                            ForEach(offVM.listOfOffenses) { off in
                                Text(off.name)
                                Text(off.date.formatted())
                                
                                
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
                                    //removeObj(at: deletedIndex ?? IndexSet(integer: Int(0)))
                                    forgive.toggle()
                                }
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
                                sheetVIew(offVm: offVM, isCopShowing: $isCopShowing)
                                    .presentationDetents([.fraction(0.20)])
                                    .presentationDragIndicator(.visible)
                            }
                            .padding()
                            .scrollContentBackground(.hidden)
                        case .failed(let error):
                            Text("Something bad happened oops: \(error.localizedDescription)")
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
    }
}
#Preview {
    ContentView()
}
