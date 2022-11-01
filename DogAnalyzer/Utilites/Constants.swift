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

let successMessage = "success"
let titleErrorMessage = "NO TITLE FOUND"
let wikiErrorMessage = "No associated Wiki found"

// Support images for DogCEO
// Used to find match so we can grab addition dog pictures of match breed
let typeOfBreeds = [
    "affenpinscher",
    "african",
    "airedale",
    "akita",
    "appenzeller",
    "australian shepherd",
    "basenji",
    "beagle",
    "bluetick",
    "borzoi",
    "bouvier",
    "boxer",
    "brabancon",
    "briard",
    "norwegian buhund",
    "boston bulldog",
    "english bulldog",
    "french bulldog",
    "staffordshire bullterrier",
    "australian cattledog",
    "chihuahua",
    "chow",
    "clumber",
    "cockapoo",
    "collie",
    "coonhound",
    "cardigan corgi",
    "cotondetulear",
    "dachshund",
    "dalmatian",
    "great dane",
    "scottish deerhound",
    "dhole",
    "dingo",
    "doberman",
    "norwegian elkhound",
    "entlebucher",
    "eskimo",
    "finnish lapphund",
    "bichon frise",
    "germanshepherd",
    "golden",
    "italian greyhound",
    "groenendael",
    "havanese",
    "afghan hound",
    "basset hound",
    "blood hound",
    "english hound",
    "ibizan hound",
    "plott hound",
    "walker hound",
    "husky",
    "keeshond",
    "kelpie",
    "komondor",
    "kuvasz",
    "labradoodle",
    "labrador",
    "leonberg",
    "lhasa",
    "malamute",
    "malinois",
    "maltese",
    "bull mastiff" ,
    "english mastiff",
    "tibetan mastiff",
    "mexicanhairless",
    "mix",
    "bernese mountain",
    "swiss mountain",
    "newfoundland",
    "otterhound",
    "caucasian ovcharka",
    "papillon",
    "pekinese",
    "pembroke",
    "miniature pinscher",
    "pitbull",
    "pointer german",
    "pointer germanlonghair",
    "pomeranian",
    "medium poodle",
    "miniature poodle",
    "standard poodle",
    "toy poodle",
    "pug",
    "puggle",
    "pyrenees",
    "redbone",
    "chesapeake retriever",
    "curly retriever",
    "flatcoated retriever",
    "golden retriever",
    "rhodesian ridgeback",
    "rottweiler",
    "saluki",
    "samoyed",
    "schipperke",
    "giant schnauzer",
    "miniature schnauzer",
    "segugio italian",
    "english settere",
    "gordon settere",
    "irish settere",
    "sharpei",
    "english sheepdog",
    "shetland sheepdog",
    "shiba",
    "shihtzu",
    "blenheim spaniel",
    "brittany spaniel",
    "cocker spaniel",
    "irish spaniel",
    "japanese spaniel",
    "sussex spaniel",
    "welsh spaniel",
    "english springer",
    "stbernard",
    "american terrier",
    "australian terrier",
    "bedlington terrier",
    "border terrier",
    "cairn terrier",
    "dandie terrier",
    "fox terrier",
    "irish terrier",
    "kerryblue terrier",
    "lakeland terrier",
    "norfolk terrier",
    "norwich terrier",
    "patterdale terrier",
    "russell terrier",
    "scottish terrier",
    "sealyham terrier",
    "silky terrier",
    "tibetan terrier",
    "toy terrier",
    "welsh terrier",
    "westhighland terrier",
    "wheaten terrier",
    "yorkshire terrier",
    "tervuren",
    "vizsla",
    "spanish waterdog",
    "weimaraner",
    "whippet",
    "irish wolfhound"
]

