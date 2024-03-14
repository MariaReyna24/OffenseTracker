//
//  Confirmation.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/11/24.
//
//
// make this an alert screen to confirm the offense was taken

import SwiftUI
import Vortex

struct Confirmation: View {
    var linear = LinearGradient(colors: [.red,.orange], startPoint: .top, endPoint: .bottom)
    var linear2 = LinearGradient(colors: [.orange,.red], startPoint: .top, endPoint: .bottom)
    var controlPoint = 0.0
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack() {
                VortexView(.fire) {
                    RoundedRectangle(cornerRadius: 250)
                        .fill(.red)
                        .blendMode(.plusLighter)
                        .frame(height: 200)
                        .tag("circle")
                        .containerRelativeFrame(.vertical)
                }
            }
            VStack{
                Text("SLOTH COP SEES ALL")
                    .foregroundStyle(linear)
                    .font(.largeTitle)
                    .bold()
                Image(.newCop)
                    .resizable()
                    .scaledToFit()
                Text("The offense has been noted Thank you for your unyielding loyalty")
                    .font(.title)
                    .foregroundStyle(linear2)
                    .bold()
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    Confirmation()
}
