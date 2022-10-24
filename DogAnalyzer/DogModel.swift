//
//  DogModel.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import Foundation

class DogModel: ObservableObject {
    
    @Published var dog = Dog()
    
    func getDogs() {
        
        let url = URL(string: dogUrl)
        
        guard url != nil else {
            print("ERROR! Unable to create URL object")
            return
        }
        
        let session = URLSession.shared
        let data = session.dataTask(with: url!) { data, response, error in
            if error == nil {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
                        
                        let item = json.isEmpty ? [:] : json[0]
                        
                        if let dog = Dog(json: item) {
                            DispatchQueue.main.async {
                                while dog.imageData == nil {}
                                self.dog = dog
                            }
                        }
                        
                    }
                } catch let failure{
                    print("ERROR! \(failure)")
                }
                
            }
        }
        
        data.resume()
    }
    
}
