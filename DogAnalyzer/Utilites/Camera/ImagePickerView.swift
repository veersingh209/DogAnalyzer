//
//  ImagePickerView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/25/22.
//

// SwiftUI doesn't support Camera natively so wrapping UIImagePickerController in a struct which conforms to UIViewControllerRepresentable

import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType?
    
    @Environment(\.presentationMode) var isPresented

        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType!
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
