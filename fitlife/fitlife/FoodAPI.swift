//
//  FoodAPI.swift
//  fitlife
//
//  Created by Saamer Arshad on 11/19/24.
//



import SwiftUI
import Foundation

//The Food Object: All Necessary Food Information.
struct FoodObject: Hashable, Codable{
    let label: String
    let image: String
    let nutritionType: String //= "logging" //Analyze single food items or portions to log daily nutritional intake.
    let calories: String
    
    //Nested Struct for Nutrients
    struct FoodNutrients: Hashable, Codable{
        
        
    }
}
