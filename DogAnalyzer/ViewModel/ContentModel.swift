//
//  ContentModel.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import CoreML
import Vision
import WikipediaKit

enum SourceImageSelection: Identifiable {
    case allSources,
         dogCEO,
         dopAPI
    
    var id: String {
        "hash"
    }
}

enum AppColorSelection: Identifiable {
    case system,
         dark,
         light
    
    var id: String {
        "hash"
    }
}

class ContentModel: ObservableObject {
    
    @Published var dog = Dog()
    @Published var imageData: Data?
    
    @Published var identifier: String?
    @Published var confidence: Double?
    @Published var dogInfo: String?
    @Published var loading: Bool
    
    @Published var colorSelection: AppColorSelection?
    @Published var imageSelection: SourceImageSelection?
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    init() {
        self.imageData = nil
        self.identifier = nil
        self.confidence = nil
        self.dogInfo = nil
        self.loading = true
        
        self.getDogData()
    }
    
    func newCameraImage(image: Data?) {
        DispatchQueue.main.async {
            self.imageData = image
            
            self.identifier = nil
            self.confidence = nil
            self.dogInfo = nil
            self.loading = true
            
            self.classifyAnimal(image: image)
        }
    }
    
    func setLoadingTrue() {
        DispatchQueue.main.async {
            self.loading = true
        }
    }
    
    func setLoadingFalse() {
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    
    func getDogData() {
        self.loading = true
        if let url = URL(string: dogCeoURL) {
            
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { data, respone, error in
                
                if error == nil {
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(Dog.self, from: data!)
                        
                        if results.status == successMessage {
                            DispatchQueue.main.async {
                                results.id = UUID()
                                self.getImageData(imageUrl: results.message)
                                self.dog = results
                            }
                        }
                        
                    } catch {
                        print("ERROR! Unable to parse JSON Data: \(error)")
                    }
                    
                } else {
                    print("ERROR! Unable to reach Dog API: \(String(describing: error))")
                }
            }
            
            dataTask.resume()
        }
    }
    
    func getImageData(imageUrl: String?) {
        
        if let url = URL(string: imageUrl!) {
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        self.imageData = data!
                        self.classifyAnimal(image: self.imageData)
                    }
                    
                } else {
                    print("ERROR! Unable to retrieve image data: \(String(describing: error))")
                }
            }
            dataTask.resume()
        }
        
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
        self.loading = false
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
