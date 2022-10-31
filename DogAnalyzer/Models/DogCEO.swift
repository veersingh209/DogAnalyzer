//
//  DogCEO.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import Foundation

class DogCEO: Decodable, Identifiable, ObservableObject {
    
    var id:UUID?
    var status: String?
    var message: String?
    var code: Int?
    
    
    init(id: UUID = UUID(), status: String? = nil, message: String? = nil, code: Int? = nil) {
        self.id = id
        self.status = status
        self.message = message
        self.code = code
    }

}

class DogCEOArray: Decodable, Identifiable, ObservableObject {
    
    var id:UUID?
    var status: String?
    var message: [String?]
    var code: Int?
    
    
    init(id: UUID = UUID(), status: String? = nil, message: [String?] = [String?](), code: Int? = nil) {
        self.id = id
        self.status = status
        self.message = message
        self.code = code
    }

}
