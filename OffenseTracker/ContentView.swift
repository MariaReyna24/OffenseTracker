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
    @State var showingSheet = false
    @State var isCopShowing = false
    @ObservedObject var sounds = SoundManager()
    @State var randomDouble = 180.0
    @State var randomPosition = CGPoint(x: 200, y: 400)
    @Environment(\.managedObjectContext) private var viewContext
    @State private var bounce = false
    @FetchRequest(sortDescriptors: []) private var offs: FetchedResults<Offense>
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
                // I stole this code from alex
                    .offset(y: bounce ? -20 :150)
                    .onAppear() {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            bounce.toggle()
                        }
                    }
                VStack {
                    List {
                        ForEach(offs) { off in
                            Text("\(off.name ?? "Ex") on  \(off.date?.formatted(date: .long, time: .shortened) ?? "ex date"))")
                                .foregroundStyle(.black)
                                .listRowBackground(Color.white.opacity(0.8))
                        } //.onDelete(perform: delteOffense)
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
                        sheetVIew(isCopShowing: $isCopShowing)
                            .presentationDetents([.fraction(0.20)])
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            
        }
    }
}


