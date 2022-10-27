//
//  Dog.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import Foundation

class Dog: Decodable, Identifiable, ObservableObject {
    
//    @Published var imageData: Data?
    
    var id:UUID?
    var message: String?
    var status: String?
    
    init(id: UUID = UUID(), message: String? = nil, status: String? = nil) {
        self.id = id
        self.message = message
        self.status = status
    }

}
