//
//  TheDogAPI.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/28/22.
//

import Foundation

class TheDogAPI: Codable, Identifiable, ObservableObject {
    
    var id:String?
    var url: String?
    var width: Int?
    var height: Int?

    init(id: String? = nil, url: String? = nil, width: Int? = nil, height: Int? = nil) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
    }
}
