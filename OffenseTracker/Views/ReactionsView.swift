//
//  ReactionsView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 5/21/24.
//

import SwiftUI

struct ReactionsView: View {
    @ObservedObject var offVM = Offenses()
    var body: some View {
        HStack{
            ForEach(offVM.reactions){ reaction in
                Button {
                    if let index = offVM.reactions.firstIndex(where: { $0.id == reaction.id }) {
                        offVM.reactions[index].count += 1
                    }
                } label: {
                    Text("\(reaction.emoji) \(reaction.count)")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(50)
                }
            }
        }
    }
}

#Preview {
    ReactionsView()
}
