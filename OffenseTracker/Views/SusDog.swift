//
//  SusDog.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/20/24.
//

import SwiftUI

struct SusDog: View {
    @State var name = ""
    @ObservedObject var sounds = SoundManager()
    var body: some View {
        Image(.sussy)
            .resizable()
            .frame(width: 300,height: 300)
        TextField("Enter name", text: $name)
    }
    
}


#Preview {
    SusDog()
}
