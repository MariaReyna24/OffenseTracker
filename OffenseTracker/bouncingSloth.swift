//
//  bouncingSloth.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 4/19/24.
//

import SwiftUI

struct bouncingSloth: View {
    @State var randomDouble = 180.0
    @State var randomPosition = CGPoint(x: 200, y: 400)
    @State private var bounce = false
    var body: some View{
        Image(.loneSloth)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(randomDouble))
            .position(randomPosition)
            .offset(y: bounce ? -20 :150)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(2)) {
                    bounce.toggle()
                }
            }
    }
}
#Preview {
    bouncingSloth()
}
