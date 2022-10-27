//
//  DogModel.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import CoreML
import Vision
import WikipediaKit

class DogModel: ObservableObject {
    var imageUrl: String
    @Published var identifier: String?
    @Published var confidence: Double?
    @Published var imageData: Data?
    @Published var dogInfo: String?
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    init() {
        self.identifier = nil
        self.confidence = nil
        self.imageData = nil
        self.dogInfo = nil
        self.imageUrl = ""
    }
    
    init(image: Data?) {
        self.imageData = image
        self.identifier = nil
        self.confidence = nil
        self.dogInfo = nil
        self.imageUrl = ""
        
        self.classifyAnimal(image: image)
    }
    
    init?(json: [String:Any]) {
        
        guard let imageUrl = json["url"] as? String else {
            return nil
        }
        self.identifier = nil
        self.confidence = nil
        self.imageData = nil
        self.dogInfo = nil
        self.imageUrl = imageUrl
        
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
                self.classifyAnimal(image: self.imageData)
            }
            
        }
        
        dataTask.resume()
    }
    
    func classifyAnimal(image: Data?) {
        
        let model = try! VNCoreMLModel(for: modelFile.model)
        let handler = VNImageRequestHandler(data: image!)
        
        // Create request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // Make sure we were able to get results
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Could not classify animal")
                return
            }
            
            self.identifier = results[0].identifier
            self.confidence = Double(results[0].confidence)
            
            self.identifier = self.identifier!.prefix(1).capitalized + self.identifier!.dropFirst()
            
        }
        
        // Execute request
        do {
            try handler.perform([request])
        } catch {
            print("Invalid image")
        }
        
        self.wikiInfo(dogBreed: self.identifier!)
        
    }
    
    func wikiInfo(dogBreed: String) {
        var htmlText = " "
        
        let language = WikipediaLanguage("en")
        
        // Remove words after commma, and delete and occurances of the word 'dog'
        let prefix = dogBreed.prefix(while: { $0 != "," }).replacingOccurrences(of: " dog", with: "")
        
        let _ = Wikipedia.shared.requestArticle(language: language, title: prefix, imageWidth: 10) { result in
            switch result {
            case .success(let article):
                self.identifier = prefix
                
                htmlText = article.displayText.slice(from: "<p>", to: "</p>")!
                htmlText = (htmlText.components(separatedBy: CharacterSet.decimalDigits)).joined(separator: "")
                htmlText = htmlText.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                
                self.dogInfo = htmlText.html2String
                
                if htmlText.contains(" refer to:") || htmlText.contains(" refers to:"){
                    
                    print("Unable to find Wiki response, retring with dog suffix")
                    let _ = Wikipedia.shared.requestArticle(language: language, title: String("\(prefix) (dog)"), imageWidth: 10) { result in
                        switch result {
                        case .success(let article):
                            htmlText = article.displayText.slice(from: "<p>", to: "</p>")!
                                .components(separatedBy: CharacterSet.decimalDigits)
                                .joined(separator: "").replacingOccurrences(of: "[", with: "")
                                .replacingOccurrences(of: "]", with: "")
                            
                            self.identifier = "\(prefix) (dog)"
                            self.dogInfo = htmlText.html2String
                        case .failure(_):
                            print("Error! No Wiki response found for: \(self.identifier ?? " ")")
                            self.dogInfo = nil
                        }
                    }
                }
            case .failure(_):
                print("Unable to find Wiki response for \(prefix), retrying with last option")
                
                // Get last word
                if let index = dogBreed.lastIndex(of: ",") {
                    let lastOption = String(dogBreed.suffix(from: index).dropFirst())
                    
                    let _ = Wikipedia.shared.requestArticle(language: language, title: String(lastOption), imageWidth: 10) { result in
                        switch result {
                        case .success(let article):
                            htmlText = article.displayText.slice(from: "<p>", to: "</p>")!
                                .components(separatedBy: CharacterSet.decimalDigits)
                                .joined(separator: "").replacingOccurrences(of: "[", with: "")
                                .replacingOccurrences(of: "]", with: "")
                            
                            self.identifier = lastOption
                            self.dogInfo = htmlText.html2String
                            
                        case .failure(_):
                            print("Error! No Wiki response found for: \(self.identifier ?? " ")")
                            self.dogInfo = nil
                        }
                    }
                
                }
            }
        }
        
    }
}
