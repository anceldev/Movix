//
//  TestImageCropPicker.swift
//  Memories
//
//  Created by Ancel Dev account on 29/11/24.
//

import SwiftUI

struct TestImageCropPicker: View {
    /// - View Properties
    @State private var showPicker: Bool = true
    @State private var croppedImage: UIImage?
    var body: some View {
        NavigationStack{
            VStack{
                if let croppedImage{
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 400)
                }else{
                    Text("No Image is Selected")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPicker.toggle()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                    }
                    .tint(.black)
                }
            }
            .cropImagePicker(
                show: $showPicker,
                croppedImage: $croppedImage
            )
        }
    }
}
#Preview(body: {
    TestImageCropPicker()
})
