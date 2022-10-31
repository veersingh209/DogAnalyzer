//
//  Dog.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import Foundation

class Dog: Decodable, Identifiable, ObservableObject {
    
    var id:UUID?
    var status: String?
    
    // TheDogCEO photo source
    var message: String?
    
    // TheDogAPI photo source
    var url: String?
    
    
    init(id: UUID = UUID(), status: String? = nil, message: String? = nil, url: String? = nil) {
        self.id = id
        self.status = status
        self.message = message
        self.url = url
    }

}
