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
    let nutritionType: String //= "logging" //Analyze single food items or portions to log daily nutritional intake.
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
//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//Structure for Food Response.
//struct FoodResponse: Codable{
//    let hits = [Hit] //
//    
//    struct Hit: Codable{
//        let food: FoodObject
//    }
//    
//    
//}
