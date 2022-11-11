//
//  Constants.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import Foundation

let dogCeoURL = "https://dog.ceo/api/breeds/image/random"
let dogURL = "https://api.thedogapi.com/v1/images/search/"
let wikiURL = "https://en.wikipedia.org/wiki/"
let upslashImageFromSearchTerm = "https://source.unsplash.com/random/?"
let dogCeoBreedURLPrefix = "https://dog.ceo/api/breed/"
let dogCeoBreedURLSufix = "/images/random/10"
let dogCeoBreedURLShuffleSufix = "/images/random"

let successMessage = "success"
let titleErrorMessage = "NO TITLE FOUND"
let wikiErrorMessage = "No associated Wiki found"


struct DogBreeds: Hashable {
    let dogCEOBreed: String
    var wikiSearchTerm: String
}

// Support images for DogCEO
// Support related Wiki article
let typeOfBreeds = [
    DogBreeds(dogCEOBreed: "affenpinscher", wikiSearchTerm: "Affenpinscher"),
    DogBreeds(dogCEOBreed: "african", wikiSearchTerm: "African wild dog"),
    DogBreeds(dogCEOBreed: "airedale", wikiSearchTerm: "Airedale Terrier"),
    DogBreeds(dogCEOBreed: "akita", wikiSearchTerm: "Akita (dog)"),
    DogBreeds(dogCEOBreed: "appenzeller", wikiSearchTerm: "Appenzeller Sennenhund"),
    DogBreeds(dogCEOBreed: "australian", wikiSearchTerm: "Australian Cattle Dog"),
    DogBreeds(dogCEOBreed: "beagle", wikiSearchTerm: "Beagle"),
    DogBreeds(dogCEOBreed: "bluetick", wikiSearchTerm: "Bluetick Coonhound"),
    DogBreeds(dogCEOBreed: "borzoi", wikiSearchTerm: "Borzoi"),
    DogBreeds(dogCEOBreed: "bouvier", wikiSearchTerm: "Bernese Mountain Dog"),
    DogBreeds(dogCEOBreed: "boxer", wikiSearchTerm: "Boxer (dog)"),
    DogBreeds(dogCEOBreed: "briard", wikiSearchTerm: "Briard"),
    DogBreeds(dogCEOBreed: "buhund", wikiSearchTerm: "Norwegian Buhund"),
    DogBreeds(dogCEOBreed: "bullterrier", wikiSearchTerm: "Bull Terrier"),
    DogBreeds(dogCEOBreed: "cattledog", wikiSearchTerm: "Australian Cattle Dog"),
    DogBreeds(dogCEOBreed: "chihuahua", wikiSearchTerm: "Chihuahua (dog)"),
    DogBreeds(dogCEOBreed: "chow", wikiSearchTerm: "Chow Chow"),
    DogBreeds(dogCEOBreed: "clumber", wikiSearchTerm: "Clumber Spaniel"),
    DogBreeds(dogCEOBreed: "cockapoo", wikiSearchTerm: "Cockapoo"),
    DogBreeds(dogCEOBreed: "collie", wikiSearchTerm: "Collie"),
    DogBreeds(dogCEOBreed: "coonhound", wikiSearchTerm: "Coonhound"),
    DogBreeds(dogCEOBreed: "corgi", wikiSearchTerm: "Welsh Corgi"),
    DogBreeds(dogCEOBreed: "cotondetulear", wikiSearchTerm: "Coton de Tulear"),
    DogBreeds(dogCEOBreed: "dalmatian", wikiSearchTerm: "Dalmatian (dog)"),
    DogBreeds(dogCEOBreed: "dane", wikiSearchTerm: "Great Dane"),
    DogBreeds(dogCEOBreed: "deerhound", wikiSearchTerm: "Scottish Deerhound"),
    DogBreeds(dogCEOBreed: "dhole", wikiSearchTerm: "Dhole"),
    DogBreeds(dogCEOBreed: "dingo", wikiSearchTerm: "Dingo"),
    DogBreeds(dogCEOBreed: "doberman", wikiSearchTerm: "Dobermann"),
    DogBreeds(dogCEOBreed: "elkhound", wikiSearchTerm: "Norwegian Elkhound"),
    DogBreeds(dogCEOBreed: "entlebucher", wikiSearchTerm: "Entlebucher Mountain Dog"),
    DogBreeds(dogCEOBreed: "eskimo", wikiSearchTerm: "Canadian Eskimo Dog"),
    DogBreeds(dogCEOBreed: "finnish", wikiSearchTerm: "Finnish Lapphund"),
    DogBreeds(dogCEOBreed: "germanshepherd", wikiSearchTerm: "German Shepherd"),
    DogBreeds(dogCEOBreed: "golden", wikiSearchTerm: "Golden Retriever"),
    DogBreeds(dogCEOBreed: "greyhound", wikiSearchTerm: "Greyhound"),
    DogBreeds(dogCEOBreed: "groenendael", wikiSearchTerm: "elgian Shepherd"),
    DogBreeds(dogCEOBreed: "havanese", wikiSearchTerm: "Havanese dog"),
    DogBreeds(dogCEOBreed: "hound", wikiSearchTerm: "Hound"),
    DogBreeds(dogCEOBreed: "husky", wikiSearchTerm: "Husky"),
    DogBreeds(dogCEOBreed: "keeshond", wikiSearchTerm: "Keeshond"),
    DogBreeds(dogCEOBreed: "kuvasz", wikiSearchTerm: "Kuvasz"),
    DogBreeds(dogCEOBreed: "labradoodle", wikiSearchTerm: "Labradoodle"),
    DogBreeds(dogCEOBreed: "labrador", wikiSearchTerm: "Labrador Retriever"),
    DogBreeds(dogCEOBreed: "leonberg", wikiSearchTerm: "Leonberger"),
    DogBreeds(dogCEOBreed: "lhasa", wikiSearchTerm: "Lhasa Apso"),
    DogBreeds(dogCEOBreed: "malamute", wikiSearchTerm: "Alaskan Malamute"),
    DogBreeds(dogCEOBreed: "malinois", wikiSearchTerm: "Belgian Shepherd"),
    DogBreeds(dogCEOBreed: "maltese", wikiSearchTerm: "Maltese dog"),
    DogBreeds(dogCEOBreed: "mastiff", wikiSearchTerm: "Mastiff"),
    DogBreeds(dogCEOBreed: "mexicanhairless", wikiSearchTerm: "Xoloitzcuintle"),
    DogBreeds(dogCEOBreed: "mix", wikiSearchTerm: "Mongrel"),
    DogBreeds(dogCEOBreed: "mountain", wikiSearchTerm: "Mountain dog"),
    DogBreeds(dogCEOBreed: "newfoundland", wikiSearchTerm: "Newfoundland dog"),
    DogBreeds(dogCEOBreed: "otterhound", wikiSearchTerm: "Otterhound"),
    DogBreeds(dogCEOBreed: "ovcharka", wikiSearchTerm: "Caucasian Shepherd Dog"),
    DogBreeds(dogCEOBreed: "pekinese", wikiSearchTerm: "Pekingese"),
    DogBreeds(dogCEOBreed: "pembroke", wikiSearchTerm: "Pembroke Welsh Corgi"),
    DogBreeds(dogCEOBreed: "pitbull", wikiSearchTerm: "Pit bull"),
    DogBreeds(dogCEOBreed: "pointer", wikiSearchTerm: "Pointing dog"),
    DogBreeds(dogCEOBreed: "pomeranian", wikiSearchTerm: "Pomeranian dog"),
    DogBreeds(dogCEOBreed: "poodle", wikiSearchTerm: "Poodle"),
    DogBreeds(dogCEOBreed: "pug", wikiSearchTerm: "Pug"),
    DogBreeds(dogCEOBreed: "puggle", wikiSearchTerm: "Puggle"),
    DogBreeds(dogCEOBreed: "pyrenees", wikiSearchTerm: "Pyrenean Mountain Dog"),
    DogBreeds(dogCEOBreed: "redbone", wikiSearchTerm: "Redbone Coonhound"),
    DogBreeds(dogCEOBreed: "retriever", wikiSearchTerm: "Retriever"),
    DogBreeds(dogCEOBreed: "pinscher", wikiSearchTerm: "Pinscher"),
    DogBreeds(dogCEOBreed: "ridgeback", wikiSearchTerm: "Rhodesian Ridgeback"),
    DogBreeds(dogCEOBreed: "rottweiler", wikiSearchTerm: "Rottweiler"),
    DogBreeds(dogCEOBreed: "saluki", wikiSearchTerm: "Saluki"),
    DogBreeds(dogCEOBreed: "samoyed", wikiSearchTerm: "Samoyed dog"),
    DogBreeds(dogCEOBreed: "schipperke", wikiSearchTerm: "Schipperke"),
    DogBreeds(dogCEOBreed: "schnauzer", wikiSearchTerm: "Schnauzer"),
    DogBreeds(dogCEOBreed: "segugio", wikiSearchTerm: "Segugio Italiano"),
    DogBreeds(dogCEOBreed: "setter", wikiSearchTerm: "Setter"),
    DogBreeds(dogCEOBreed: "sheepdog", wikiSearchTerm: "Sheep dog"),
    DogBreeds(dogCEOBreed: "shiba", wikiSearchTerm: "Shiba Inu"),
    DogBreeds(dogCEOBreed: "shihtzu", wikiSearchTerm: "Shih Tzu"),
    DogBreeds(dogCEOBreed: "spaniel", wikiSearchTerm: "Spaniel"),
    DogBreeds(dogCEOBreed: "springer", wikiSearchTerm: "English Springer Spaniel"),
    DogBreeds(dogCEOBreed: "stbernard", wikiSearchTerm: "St. Bernard (dog)"),
    DogBreeds(dogCEOBreed: "terrier", wikiSearchTerm: "Terrier"),
    DogBreeds(dogCEOBreed: "tervuren", wikiSearchTerm: "Belgian Shepherd"),
    DogBreeds(dogCEOBreed: "vizsla", wikiSearchTerm: "Vizsla"),
    DogBreeds(dogCEOBreed: "waterdog", wikiSearchTerm: "Spanish Water Dog"),
    DogBreeds(dogCEOBreed: "weimaraner", wikiSearchTerm: "Weimaraner"),
    DogBreeds(dogCEOBreed: "whippet", wikiSearchTerm: "Whippet"),
    DogBreeds(dogCEOBreed: "wolfhound", wikiSearchTerm: "Irish Wolfhound"),
]
