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
    @Published var selectedBreed: String
    @Published var isOnboarding: Bool
    
    // Store separate image/name for list view to not effect home view when modal dismissed
    @Published var imageDataListView: Data?
    @Published var identifierListView: String?
    @Published var viewingListView: Bool = false
    
    @Published var colorSelection: AppColorSelection
    @Published var imageSelection: SourceImageSelection
    
    var lastURL: String?
    
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
        self.selectedBreed = typeOfBreeds[0]
        
        self.getDogData()
    }
    
    // Fetch new image for ListView
    func setNewBreed(selectedBreed: String? = typeOfBreeds[0]) {
        DispatchQueue.main.async {
            self.viewingListView = true
            
            self.identifier = nil
            self.confidence = nil
            self.dogInfo = nil
            self.loading = true
            self.selectedBreed = selectedBreed!
            
            self.getDogData(breed: self.selectedBreed)
        }
    }
    
    // Reset after viewing ListView
    func resetURLtoLastKnown() {
        DispatchQueue.main.async {
            self.viewingListView = false
            self.loading = true
            
            self.identifier = nil
            self.confidence = nil
            self.dogInfo = nil
            self.selectedBreed = typeOfBreeds[0]
            
            self.getImageData(imageUrl: self.lastURL)
        }
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
    
    func getDogData(breed: String? = nil) {
        self.loading = true
        var selectedSourceURL = ""
        
        if breed != nil {
            selectedSourceURL = "\(dogCeoBreedURLPrefix)\(breed!)\(dogCeoBreedURLListSufix)"
        } else {
            switch self.imageSelection {
            case .dogCEO:
                selectedSourceURL = dogCeoURL
            case .dogAPI:
                selectedSourceURL = dogURL
            }
        }
        
        if let url = URL(string: selectedSourceURL) {
            
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                
                if error == nil && data != nil {
                    
                    do {
                        
                        // If in List view use dogCEO, as it supports breed searches
                        if breed != nil {
                            let results = try decoder.decode(DogCEO.self, from: data!)
                            
                            if results.status == successMessage {
                                DispatchQueue.main.async {
                                    results.id = UUID()
                                    self.getImageData(imageUrl: results.message)
                                }
                            }
                        } else {
                            // Get data based on user selected source
                            switch self.imageSelection {
                            case .dogCEO:
                                
                                let results = try decoder.decode(DogCEO.self, from: data!)
                                
                                if results.status == successMessage {
                                    DispatchQueue.main.async {
                                        results.id = UUID()
                                        self.lastURL = results.message
                                        self.getImageData(imageUrl: results.message)
                                    }
                                }
                                
                            case .dogAPI:
                                
                                let results = try decoder.decode([TheDogAPI].self, from: data!)
                                if !results.isEmpty {
                                    let item = results[0]
                                    DispatchQueue.main.async {
                                        self.lastURL = item.url
                                        self.getImageData(imageUrl: item.url)
                                    }
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
        else {
            print("ERROR! Not able to set URL: \(selectedSourceURL)")
        }
    }
    
    func getImageData(imageUrl: String?) {
        if let url = URL(string: imageUrl!) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    DispatchQueue.main.async {
                        if self.viewingListView {
                            self.imageDataListView = data!
                            self.classifyAnimal(image: self.imageDataListView)
                        } else {
                            self.imageData = data!
                            self.classifyAnimal(image: self.imageData)
                        }
                        
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
            if self.viewingListView {
                self.identifierListView = results[0].identifier
                
                self.identifier = self.identifierListView!.prefix(1).capitalized + self.identifierListView!.dropFirst()
            } else {
                self.identifier = results[0].identifier
                
                self.identifier = self.identifier!.prefix(1).capitalized + self.identifier!.dropFirst()
            }
            
            self.confidence = Double(results[0].confidence)
            
        }
        
        do {
            try handler.perform([request])
        } catch {
            print("Invalid image")
        }
        
        if self.viewingListView {
            self.wikiInfo(dogBreed: self.identifierListView!)
        } else {
            self.wikiInfo(dogBreed: self.identifier!)
        }
        
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
                            print("Revived error response from API")
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
