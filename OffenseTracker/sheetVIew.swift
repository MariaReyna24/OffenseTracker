//
//  sheetVIew.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI

struct sheetVIew: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = OffenseViewModel()
    @State private var newOffense = ""
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
                    vm.addOffense(name: newOffense)
                    vm.saveOffenses()
                    newOffense = ""
                    dismiss()
                    
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
}

#Preview {
    sheetVIew()
}
