//
//  ContentModel.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import CoreML
import Vision
import WikipediaKit

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
    @Published var selectedImage: Data?
    
    @Published var dog: DogBreeds?
    @Published var confidence: Double?
    @Published var dogInfo: String?
    @Published var loading: Bool
    @Published var isOnboarding: Bool
    @Published var shuffleMode: Bool = false
    @Published var imageURL: String?
    
    @Published var colorSelection: AppColorSelection
    
    //Store values to use in Picker in ShuffleDetailView
    @Published var selectedBreed: String
    
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
        
        self.shuffleMode = true
        self.dog = typeOfBreeds.randomElement()!
        self.imageData = nil
        self.confidence = nil
        self.dogInfo = nil
        self.loading = true
        self.selectedBreed = ""
        
        self.getDogData(breed: self.dog!.dogCEOBreed)
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
    
    // Fetch new dog for when shuffle button pressed
    func setNewBreed(selectedBreed: DogBreeds) {
        DispatchQueue.main.async {
            self.shuffleMode = true
            self.dog = selectedBreed
            self.imageData = nil
            self.confidence = nil
            self.dogInfo = nil
            self.loading = true
            self.selectedBreed = selectedBreed.dogCEOBreed
            
            self.getDogData(breed: self.selectedBreed)
        }
    }
    
    // Fetch new dog when selected from Picker within ShuffleDetailView
    func selectNewBreedPicker(newBreed: String) {
        DispatchQueue.main.async {
            self.shuffleMode = true
            self.dog = DogBreeds(dogCEOBreed: newBreed, wikiSearchTerm: newBreed)
            self.imageData = nil
            self.confidence = nil
            self.dogInfo = nil
            self.loading = true
            self.selectedBreed = self.dog!.dogCEOBreed
            
            self.findAssociatedDog(breedSelected: self.selectedBreed)
        }
    }
    
    func newCameraImage(image: Data?) {
        DispatchQueue.main.async {
            self.shuffleMode = false
            self.imageData = image
            self.confidence = nil
            self.dogInfo = nil
            self.loading = true
            
            self.dog = nil
            self.selectedBreed = ""
            
            self.classifyAnimal(image: image)
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
    
    // Used to set selected image from Similar WebImages within the detail view
    func setSelectedImage(image: Data) {
        DispatchQueue.main.async {
            self.selectedImage = image
        }
    }
    
    // Find matching WikiSearch term
    func findAssociatedDog(breedSelected: String) {
        for dog in typeOfBreeds {
            if dog.dogCEOBreed == breedSelected {
                self.dog!.wikiSearchTerm = dog.wikiSearchTerm
            }
        }
        self.getDogData(breed: self.selectedBreed)
    }
    
    
    func getDogData(breed: String? = nil, checkWithFirstWord: Bool? = false, checkWithMiddleWord: Bool? = false, checkWithLastWord: Bool? = true) {
        DispatchQueue.main.async {
            self.loading = true
            
            if breed != nil {
                   self.selectedBreed = breed!
            }
            let selectedSourceURL = "\(dogCeoBreedURLPrefix)\(self.selectedBreed)\(dogCeoBreedURLShuffleSufix)"

            
            if let url = URL(string: selectedSourceURL) {
                
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
                request.httpMethod = "GET"
                
                let session = URLSession.shared
                
                let dataTask = session.dataTask(with: request) { data, response, error in
                    let decoder = JSONDecoder()
                    
                    if error == nil && data != nil {
                        
                        do {
                            
                            // If in shuffle view use dogCEO, as it supports breed searches
                            if breed != nil {
                                let results = try decoder.decode(DogCEO.self, from: data!)
                                
                                if results.status == successMessage {
                                    DispatchQueue.main.async {
                                        results.id = UUID()
                                        self.getImageData(imageUrl: results.message)
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
    }
    
    func getImageData(imageUrl: String?) {
        if let url = URL(string: imageUrl!) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    DispatchQueue.main.async {
                        if self.shuffleMode {
                            self.imageData = data!
                            self.wikiInfo(dogBreed: self.dog!.wikiSearchTerm)
                            self.loading = false
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
            var result = results[0].identifier
            result = result.prefix(1).capitalized + result.dropFirst()
            self.dog = DogBreeds(dogCEOBreed: result, wikiSearchTerm: result)

            self.confidence = Double(results[0].confidence)
        }
        
        do {
            try handler.perform([request])
        } catch {
            print("Invalid image")
        }
            self.wikiInfo(dogBreed: self.dog!.wikiSearchTerm)
        
        self.loading = false
    }
    
    func wikiInfo(dogBreed: String) {
        let _ = Wikipedia.shared.requestSearchResults(method: WikipediaSearchMethod.fullText, language: WikipediaLanguage("en"), term: dogBreed) { (data, error) in
            guard error == nil else {
                print("ERROR! Unable to find Wiki response")
                self.dogInfo = nil
                return
            }
            guard let resultData = data else { return }
            
            for wikiData in resultData.items {
                self.dogInfo = wikiData.displayText
                break
            }
        }
        if self.shuffleMode {
            self.similarResultsImageData.removeAll()
            self.getImageSimilarResults(breed: self.dog!.dogCEOBreed)
        } else {
            self.similarResultsImageData.removeAll()
            self.matchBreed(breedGiven: self.dog!.dogCEOBreed)
        }
    }
    
    // Match breed to only in constants array
    // Need to then use image results from DogCEO
    func matchBreed(breedGiven: String) {
        var highest = [Double]()
        var highestIndex:Int?
        
        for breed in typeOfBreeds {
            highest.append(breedGiven.levenshteinDistanceScore(to: breed.dogCEOBreed, ignoreCase: true, trimWhiteSpacesAndNewLines: false))
            
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
            print("Match found! Finding additional dog images")
            self.getImageSimilarResults(breed: typeOfBreeds[highestIndex!].dogCEOBreed)
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
        let searchTerm = self.dog!.dogCEOBreed.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: "\(upslashImageFromSearchTerm)\(searchTerm)") {
            // disable cache to retrive different images
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
