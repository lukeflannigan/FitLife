//
//  FoodAPI.swift
//  fitlife
//
//  Created by Saamer Arshad on 11/19/24.
//
import SwiftUI
import Foundation


//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//The Food Object: All Necessary Food Information.
struct FoodObject: Hashable, Codable{
    let label: String
    let image: String? //making an optional as not all food items may have images.
    let nutritionType: String = "logging" //Analyze single food items or portions to log daily nutritional intake.
    let calories: String
    let totalNutrients: FoodNutrients
    let servingSize: [ServingSize]?
    let servingsPerContainer: Int?
    
    //Nested Struct for Nutrients in a Food.
    struct FoodNutrients: Hashable, Codable{
        let PROCNT: Nutrient //Protein
        let CHOCDEF: Nutrient //Carbs
        let FAT: Nutrient //Fats
        let FIBTG: Nutrient //Fiber
        let SUGAR: Nutrient
        let ENERC_KCAL: Nutrient //Energy in Kilo Calories
        
        //How each one is structured.
        struct Nutrient: Hashable, Codable{
            let label: String
            let quantity: Double
            let unit: String
        }
    }
    
    struct ServingSize: Hashable, Codable{
        let uri: String?
        let label: String?
        let quantitiy: Double?
    }
}

//Measurements are dynamic and context-dependent, hence kept out of the Static FoodObject.
struct Measure: Codable, Hashable{
    let uri: String
    let label: String
    let weight: Double?
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//Structure for Food Response.
struct FoodResponse: Codable{
    
    struct ParsedFood: Codable{
        let food: FoodObject
    }
    
    struct Hint: Codable{
        let food: FoodObject
    }
    
    struct Links: Codable{
        let next: NextLink?
        }
    
    struct NextLink: Codable{
        let href: String
        let title: String
    }
    
    let parsed: [ParsedFood]
    let hints: [Hint]
    let text: String
    let _links: Links
    
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

class FoodViewModel: ObservableObject{
    @Published var foodItem: [FoodObject] = [] //Array to Hold Fetched a Food's Data
    
    func fetchData(query: String){
        if let path = Bundle.main.path(forResource: "FoodSearch", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           
    }
}


