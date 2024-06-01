//
//  sheetVIew.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import SwiftData
import CloudKit
import CoreData
import PhotosUI

struct AddOffense: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @ObservedObject var offVm: Offenses
    @Environment(\.dismiss) var dismiss
    @State var newOffense = ""
    @State private var isShowingError = false
    @Binding var isCopShowing: Bool
    var body: some View {
        ZStack{
            Image(.burningSloths)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack() {
                selectedImage?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 100)
                    .padding()
                TextField("Enter Kiana's offense", text: $newOffense)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                VStack{
                    PhotosPicker("Upload a photo", selection: $pickerItem, matching: .images)
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(50)
                        .onChange(of: pickerItem){
                            Task{
                                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                                offVm.addedImage.toggle()
                            }
                        }
                }

                Button(action: {
                    addOff()
                    dismiss()
                    withAnimation(.easeInOut(duration: 2)) {
                        isCopShowing.toggle()
                    }
                    
                }) {
                    Text("Offense taken note")
                }
                .foregroundStyle(.white)
                .padding()
                .background(.black)
                .cornerRadius(50)
            }
        }
    }
    func addOff(){
        Task {
            do {
                try await offVm.saveNewEvent(withName: newOffense, date: Date.now, emojis: ["👎"], count: 0)
                dismiss()
            } catch {
                isShowingError = true
            }
        }
      
    }

}

#Preview {
    AddOffense(offVm: Offenses(), isCopShowing: .constant(true))
}
