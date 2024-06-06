//
//  ReactionsView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 6/6/24.
//

import SwiftUI

struct ReactionsView: View {
    @StateObject var offVM = Offenses()
    @State var newCount = 0
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                List {
                    ForEach(offVM.reactions) { off in
                        HStack{
                            Text("\(off.icon.first!)")
                            Button {
                                newCount += 1
                                
                            } label: {
                                Text("\(off.count)")
                                Text("newcount: \(newCount)")
                                // need to find out logic that triggers the save of numbr of count
                                // i aslo need to fix UI so that it reflects the proper change in value
                            }.onDisappear {
                                Task{
                                    await offVM.newCountUpdate(count: off.count)
                                }
                            }
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
