//
//  ReactionsView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 6/6/24.
//

import SwiftUI

struct ReactionsView: View {
    @StateObject var offVM = Offenses()
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                List {
                 
                    ForEach(offVM.reactions) { off in
                        Button {
                            
                        } label: {
                            Text("\(off.icon), \(off.count)")
                        }
                       
                        
                    }
                   
                
                }
                .refreshable {
                    try? await offVM.fetchReactions()
                }
                .task {
                    try? await offVM.fetchReactions()
                }
                .scrollContentBackground(.hidden)

            
        }
    }
}
#Preview {
    ReactionsView()
}
