//
//  ImagePickerView.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 5/1/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    var body: some View {
        HStack{
            PhotosPicker("Upload a photo", selection: $pickerItem, matching: .images)
                .foregroundStyle(.white)
                .padding()
                .background(.black)
                .cornerRadius(50)
                .onChange(of: pickerItem){
                    Task{
                        selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                    }
                }
            selectedImage?
                .resizable()
                .scaledToFit()
                .padding()
        }
       
    }
}

#Preview {
    ImagePickerView()
}
