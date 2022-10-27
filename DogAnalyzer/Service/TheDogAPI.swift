//
//  TheDogAPI.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import Foundation

class TheDogAPI: ObservableObject {
    
    @Published var model = DogModel()
    
    func getDogs() {
        
        let url = URL(string: dogURL)
        
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
                        
                        if let dog = DogModel(json: item) {
                            DispatchQueue.main.async { [self] in
                                var counter = 0
                                while model.identifier == nil {
                                    print("LOADING \(counter)")
                                    counter += 1
                                }
                                self.model = dog
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
    
    func updateDog(image: Data?) {
        self.model = DogModel(image: image)
        
    }
    
}
