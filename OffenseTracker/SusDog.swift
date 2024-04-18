//
//  SusDog.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/20/24.
//

import SwiftUI

struct SusDog: View {
    @ObservedObject var sounds = SoundManager()
    var body: some View {
        Image(.sussy)
            .resizable()
            .frame(width: 300,height: 300)
    }
    
}


#Preview {
    SusDog()
}
