//
//  CustomImagePicker.swift
//  Memories
//
//  Created by Ancel Dev account on 29/11/24.
//

import SwiftUI
/// - For Native SwiftUI Image Picker
import PhotosUI

// MARK: View Extensions
extension View{
    @ViewBuilder
//    func cropImagePicker(options: [Crop],show: Binding<Bool>,croppedImage: Binding<UIImage?>) -> some View {
//        CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
//            self
//        }
//    }
    func cropImagePicker(show: Binding<Bool>,croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    /// - For Making it Simple and easy to use
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    /// - Haptic Feedback
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    
    init(show: Binding<Bool>,croppedImage: Binding<UIImage?>,@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
    }
    
    /// - View Properties
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .square
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { _, newValue in
                /// - Extracting UIImage From Photos Item
                if let newValue{
                    Task{
                        if let imageData = try? await newValue.loadTransferable(type: Data.self),let image = UIImage(data: imageData){
                            /// - UI Must be updated on Main Thread
                            await MainActor.run(body: {
                                selectedImage = image
                                showCropView.toggle()
                            })
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
                /// When Exited Clearing the old Selected Image
                selectedImage = nil
            } content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage{
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

struct CropView: View{
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    
    /// - View Properties
    @Environment(\.dismiss) private var dismiss
    /// - Gesture Properties
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View{
        NavigationStack{
            ImageView()
                .navigationTitle("Crop View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background {
                    Color.bw10
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            /// Converting View to Image (Native iOS 16+)
                            let renderer = ImageRenderer(content: ImageView(true))
                            renderer.scale = 10.0 // To get high quality
                            renderer.proposedSize = .init(crop.size())
                            if let image = renderer.uiImage{
                                onCrop(image,true)
                            }else{
                                onCrop(nil,false)
                            }
                            dismiss()
                        } label: {
                            Image(.done)
                                .font(.callout)
                                .foregroundStyle(.blue1)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(.close)
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    }
                }
        }
    }
    
    /// - Image View
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader{
            let size = $0.size
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { _, newValue in
                                    /// - true Dragging
                                    /// - false Stopped Dragging
                                    /// With the Help of GeometryReader
                                    /// We can now read the minX,Y and maxX,Y of the Image
                                    if !newValue{
                                        withAnimation(.easeInOut(duration: 0.2)){
                                            if rect.minX > 0{
                                                /// - Resetting to Last Location
                                                haptics(.medium)
                                                offset.width = (offset.width - rect.minX)
                                            }
                                            if rect.minY > 0{
                                                /// - Resetting to Last Location
                                                haptics(.medium)
                                                offset.height = (offset.height - rect.minY)
                                            }
                                            
                                            /// - Doing the Same for maxX,Y
                                            if rect.maxX < size.width{
                                                /// - Resetting to Last Location
                                                haptics(.medium)
                                                offset.width = (rect.minX - offset.width)
                                            }
                                            
                                            if rect.maxY < size.height{
                                                /// - Resetting to Last Location
                                                haptics(.medium)
                                                offset.height = (rect.minY - offset.height)
                                            }
                                        }
                                        
                                        /// - Storing Last Offset
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay(content: {
            /// We Don't Need Grid View for Cropped Image
            if !hideGrids{
                Grids()
            }
        })
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    /// - Limiting Beyond 1
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)){
                        if scale < 1{
                            scale = 1
                            lastScale = 0
                        }else{
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
    }
    
    /// - Grids
    @ViewBuilder
    func Grids() -> some View {
        ZStack{
            GeometryReader {
                let spacing = (($0.size.width / 2) - 2)
                
                HStack(spacing: spacing){
                    ForEach(1...3,id: \.self){_ in
                        Rectangle()
                            .fill(.blue1.opacity(0.2))
                            .frame(width: 1)
                            .frame(maxWidth: .infinity)
                    }
                }
                VStack(spacing: spacing){
                    ForEach(1...3,id: \.self){_ in
                        Rectangle()
                            .fill(.blue1.opacity(0.2))
                            .frame(height: 1)
                            .frame(maxHeight: .infinity)
                    }
                }
            }
        }
    }
}


#Preview {
    CropView(crop: .square, image: UIImage(named: "headerPreview")) { _, _ in }
}
