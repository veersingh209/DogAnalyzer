//
//  ContentModel.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import CoreML
import Vision
import WikipediaKit

enum SourceImageSelection: Int {
    case dogCEO = 1,
         dogAPI = 2
}

enum AppColorSelection: Int {
    case light = 1,
         dark = 2,
         system = 3
}

enum UserOnboardStatus: Int {
    case needsToOnboard = 1,
         onboardCompleted = 2
}

class ContentModel: ObservableObject {
    @Published var imageData: Data?
    @Published var similarResultsImageData = [Data?]()
    
    @Published var identifier: String?
    @Published var confidence: Double?
    @Published var dogInfo: String?
    @Published var loading: Bool
    
    @Published var isOnboarding: Bool
    @Published var colorSelection: AppColorSelection
    @Published var imageSelection: SourceImageSelection
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    let userDefaults = UserDefaults.standard
    
    init() {
        // Retrieve onboarding status from memory
        let userIsOnboarding = userDefaults.integer(forKey: "isOnboarding")
        switch userIsOnboarding {
        case 1:
            self.isOnboarding = true
        case 2:
            self.isOnboarding = false
        default:
            self.isOnboarding = true
        }
        
        // Retrieve Color selection from memory
        let colorChoice = userDefaults.integer(forKey: "colorSelection")
        switch colorChoice {
        case 1:
            self.colorSelection = .light
        case 2:
            self.colorSelection = .dark
        case 3:
            self.colorSelection = .system
        default:
            self.colorSelection = .light
        }
        
        // Retrieve Source selection from memory
        let sourceChoice = userDefaults.integer(forKey: "sourceSelection")
        switch sourceChoice {
        case 1:
            self.imageSelection = .dogCEO
        case 2:
            self.imageSelection = .dogAPI
        default:
            self.imageSelection = .dogCEO
        }
        
        self.imageData = nil
        self.identifier = nil
        self.confidence = nil
        self.dogInfo = nil
        self.loading = true
        
        self.getDogData()
    }
    
    func onBoardCompleted(status: UserOnboardStatus) {
        DispatchQueue.main.async {
            switch status {
            case .needsToOnboard:
                self.isOnboarding = true
            case .onboardCompleted:
                self.isOnboarding = false
            }
        }
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
    
    func setImageSource(source: SourceImageSelection) {
        DispatchQueue.main.async {
            self.imageSelection = source
        }
    }
    
    func setNewAppColor(color: AppColorSelection) {
        DispatchQueue.main.async {
            self.colorSelection = color
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
        var selectedSourceURL = ""
        
        switch self.imageSelection {
        case .dogCEO:
            selectedSourceURL = dogCeoURL
        case .dogAPI:
            selectedSourceURL = dogURL
        }
        
        if let url = URL(string: selectedSourceURL) {
            
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { data, respone, error in
                let decoder = JSONDecoder()
                
                if error == nil && data != nil {
                    
                    do {
                        
                        // Get data based on user selected source
                        switch self.imageSelection {
                        case .dogCEO:
                            
                            let results = try decoder.decode(DogCEO.self, from: data!)
                            
                            if results.status == successMessage {
                                DispatchQueue.main.async {
                                    results.id = UUID()
                                    self.getImageData(imageUrl: results.message)
                                }
                            }
                            
                        case .dogAPI:
                            
                            let results = try decoder.decode([TheDogAPI].self, from: data!)
                            if !results.isEmpty {
                                let item = results[0]
                                DispatchQueue.main.async {
                                    self.getImageData(imageUrl: item.url)
                                }
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
        
        // Remove words after comma, and delete and occurrences of the word 'dog'
        let prefix = dogBreed.prefix(while: { $0 != "," }).replacingOccurrences(of: " dog", with: "")
        
        let _ = Wikipedia.shared.requestArticle(language: language, title: prefix, imageWidth: 10) { result in
            switch result {
            case .success(let article):
                self.identifier = prefix
                
                htmlText = article.displayText.slice(from: "<p>", to: "</p>")!
                htmlText = (htmlText.components(separatedBy: CharacterSet.decimalDigits)).joined(separator: "")
                htmlText = htmlText.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                
                self.dogInfo = htmlText.html2String
                
                // Re-search if found following key terms. Mean wiki article response not actual
                if htmlText.contains(" refer to:") || htmlText.contains(" refers to:") || htmlText.contains(" may be:"){
                    
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
                
                // Get last word only
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
        self.similarResultsImageData.removeAll()
        self.matchBreed(breedGiven: self.identifier!)
    }
    
    // Match breed to only in constants array
    // Need to then use image results from DogCEO
    func matchBreed(breedGiven: String) {
        var highest = [Double]()
        var highestIndex:Int?
        
        for breed in typeOfBreeds {
            highest.append(breedGiven.levenshteinDistanceScore(to: breed, ignoreCase: true, trimWhiteSpacesAndNewLines: false))
            
        }
        for (index, element) in highest.enumerated() {
            if element == highest.max() {
                highestIndex = index
                print("Highest Number found: \(element)")
            }
            
        }
        print("Current image: \(breedGiven)")
        print("Matching name: \(typeOfBreeds[highestIndex!])")
        
        // If matching breed found
        if highest.max()! > 0.35 {
            print("Match found! Finding addional dog images")
            self.getImageSimilarResults(breed: typeOfBreeds[highestIndex!])
        } else {
            print("NO dog Match found! Using upsplash images")
            print("UPLASH: backup in use ")
            // Run 10 call to retrieve 10 different pictures
            for _ in 0..<10 {
                self.getSimilarImagesBackUp()
            }
        }

        
    }
    
    // Get additional dog images based on breed using DogCEO
    func getImageSimilarResults(breed: String) {
        
        // Use last word only
        let size = breed.reversed().firstIndex(of: " ") ?? breed.count
        let startWord = breed.index(breed.endIndex, offsetBy: -size)
        let prefix = breed[startWord...]
        let urlToUSE = "\(dogCeoBreedURLPrefix)\(prefix)\(dogCeoBreedURLSufix)"
        
        if let url = URL(string: urlToUSE) {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { data, respone, error in
                let decoder = JSONDecoder()
                
                if error == nil && data != nil {
                    do {
                        
                        let results = try decoder.decode(DogCEOArray.self, from: data!)
                        
                        if results.status == successMessage {
                            DispatchQueue.main.async {
                                
                                for result in results.message {
                                    if let url = URL(string: result!) {
                                        let session = URLSession.shared
                                        let dataTask = session.dataTask(with: url) { data, response, error in
                                            if error == nil {
                                                DispatchQueue.main.async {
                                                    self.similarResultsImageData.append(data!)
                                                }

                                            } else {
                                                print("ERROR! Unable to retrieve image data: \(String(describing: error))")
                                            }
                                        }
                                        dataTask.resume()
                                    }
                                }
                    

                            }
                        } else {
                            print("Reviced error response from API")
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
    
    // Get similar images from result
    // Back incase no matching dog breed
    // Main use case if user using camera image which doesn't contain a dog
    func getSimilarImagesBackUp() {
        // replace spaces with %20
        let searchTerm = self.identifier!.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: "\(upslashImageFromSearchTerm)\(searchTerm)") {
                // disable cache to retrive diffrent images
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
                
                let session = URLSession.init(configuration: config)
                let dataTask = session.dataTask(with: url) { data, response, error in
                    if error == nil {
                        
                        DispatchQueue.main.async {
                            self.similarResultsImageData.append(data!)
                        }
                        
                    } else {
                        print("ERROR! Unable to retrieve similar image data: \(String(describing: error))")
                    }
                }
                dataTask.resume()
            } else {
                print("ERROR! Unable to use URL")
            }

    }
    
}
