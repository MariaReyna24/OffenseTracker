//
//  ContentView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var vm = OffenseViewModel()
    @State var showingSheet = false
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.kingSloth)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    List {
                        ForEach(vm.offenses) { offense in
                            Text(offense.name)
                        } .onDelete(perform: { indexSet in
                            vm.offenses.remove(atOffsets: indexSet)
                            vm.saveOffenses()
                        })
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
                        sheetVIew(vm: vm)
                            .presentationDetents([.fraction(0.20)])
                            .presentationDragIndicator(.visible)
                    }
                }.onAppear {
                    vm.loadOffenses()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
