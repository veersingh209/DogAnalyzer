//
//  Coordinator.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/25/22.
//

// Used to get image data from camera or selected in phot library
// Acting as bridge between UIKit and SwiftUI

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        self.picker.selectedImage = selectedImage.upOrientationImage()
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}

// fix issue where captured image shows roated when displayed
extension UIImage {
    func upOrientationImage() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result!
    }
}
