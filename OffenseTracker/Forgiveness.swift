//
//  Forgiveness.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/19/24.
//

import SwiftUI
import Vortex
struct Forgiveness: View {
  //  var linear = LinearGradient(colors: [.green], startPoint: .top, endPoint: .bottom)
    var controlPoint = 0.0
    var body: some View {
        ZStack {
//            Color.white
//                .opacity(0.2)
//                .ignoresSafeArea()
            Image(.godsHome)
                .resizable()
                .ignoresSafeArea()
            VStack() {
                VortexView(.snow) {
                    Circle()
                        .fill(.white)
                        .blendMode(.plusLighter)
                        .frame(height: 20)
                        .tag("circle")
                }
            }
            VStack{
                Image(.slothA)
                    .resizable()
                    .scaledToFit()
                Text("The Sloth gods thank you for your forgivness")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .bold()
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    Forgiveness()
}
