//
//  Forgiveness.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/19/24.
//

import SwiftUI
import Vortex


enum phases: CaseIterable {
    case up, down
    var move: any Transition {
        switch self {
        case .up: MoveTransition(edge: .top)
        case .down: MoveTransition(edge: .bottom)
        }
    }
}

struct Forgiveness: View {
    @State var bounce = false
    var body: some View {
        ZStack {
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
                    .offset(y: bounce ? -20 :400)
                    .onAppear() {
                        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            bounce.toggle()
                        }
                    }
                    .phaseAnimator(phases.allCases) { content, phase in
                        content
                            .transition(.move(edge: .top))
                    }
                Text("The Sloth gods thank you for your forgivness")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .bold()
                    .multilineTextAlignment(.center)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    Forgiveness()
}
