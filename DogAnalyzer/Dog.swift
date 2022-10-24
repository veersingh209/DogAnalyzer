//
//  Dog.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import Foundation

class Dog: ObservableObject {
    
    @Published var imageURL: String
    @Published var imageData: Data?
    
    init() {
        self.imageURL = ""
        self.imageData = nil
    }
    
    init?(json: [String:Any]) {
        
        guard let imageURL = json["url"] as? String else {
            return nil
        }
        
        self.imageURL = imageURL
        self.imageData = nil
        
        getImage()
    }
    
    func getImage() {
        
    }
}
