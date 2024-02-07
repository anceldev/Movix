//
//  ImagePicker.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Environment(\.presentationMode) var mode
    
    func makeCoordinator() -> Coordinator {
        print("make makecordinator")
        return Coordinator(self)
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        print("entermakeuiviewcontroller")
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("enterupdateuiviewcontroller")
    }

}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.image = image
            parent.mode.wrappedValue.dismiss()
        }
    }
}
