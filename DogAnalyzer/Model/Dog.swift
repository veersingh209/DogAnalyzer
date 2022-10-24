//
//  Dog.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import Foundation
import CoreML
import Vision

struct Result : Identifiable {
    var imageLabel: String
    var confidence: Double
    var id = UUID()
}

class Dog: ObservableObject {
    var imageUrl: String
    
    @Published var imageData: Data?
    @Published var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json: [String:Any]) {
        
        guard let imageUrl = json["url"] as? String else {
            return nil
        }
        
        self.imageUrl = imageUrl
        self.imageData = nil
        self.results = []
        
        getImage()
    }
    
    func getImage() {
        let url = URL(string: imageUrl)
        guard url != nil else {
            print("ERROR! Unale to create url object")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                self.imageData = data
                self.classifyAnimal()
            }

        }

        dataTask.resume()
    }
    
    func classifyAnimal() {
        
        let model = try! VNCoreMLModel(for: modelFile.model)
        let handler = VNImageRequestHandler(data: imageData!)
        
        // Create request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // Make sure we were able to get results
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Could not classify animal")
                return
            }
            
            // Update our results variable
            for classification in results {
                
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))

            }
        }
        
        // Execute request
        do {
            try handler.perform([request])
        } catch {
            print("Invalid image")
        }
        
    }
}
