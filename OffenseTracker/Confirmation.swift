//
//  Confirmation.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/11/24.
//
//make this an alert screen to confirm the offense was taken
import SwiftUI
import Vortex

struct Confirmation: View {
    var body: some View {
        VStack{
            Image(.slothCop)
            Text("Your offense has been noted")
                .font(.title)
                .foregroundStyle(.black)
                .bold()
        }
    }
}

#Preview {
    Confirmation()
}
