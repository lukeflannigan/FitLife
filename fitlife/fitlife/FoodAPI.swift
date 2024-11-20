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
    @Published var foods: [FoodObject] = [] //Array to Hold Fetched a Food's Data
    
    func fetchData(ingredient: String){
        if let path = Bundle.main.path(forResource: "FoodSearch", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let id = dict["app_id"] as? String,
           let key = dict["app_key"] as? String {
            
            //     Ensure the query is URL-safe
            let encodedIngredient = ingredient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "
            
            
            //Construct the URL with the Credentials
            let URLString = "https://api.edamam.com/api/food-database/v2/parser?ingr=\(encodedIngredient)&app_id=\(id)&app_key=\(key)&nutrition-type=logging"
            print("Constructed URL: \(URLString)")
            
            //Validate the URL
            guard let url = URL(string: URLString) else{
                print("Error: Invalid Link")
                return
            }
            
            //Create the URL Session Task
            let task = URLSession.shared.dataTask(with: url){ data, response, error in
                //1. Handle Errors
                if let error = error {
                    print ("Error: \(error.localizedDescription)")
                    return
                }
                
                //2. Check for Valid Data
                guard let validData = data else{
                    print("Strange,there's nothing here... (Error: No Data Received)")
                    return
                }
                
                //Decoding the JSON Block
                do{
                    let decodedResponse = try JSONDecoder().decode(FoodResponse.self, from: validData)
                    DispatchQueue.main.async{
                        self.foods = decodedResponse.parsed.map {$0.food}
                        
                        
                        //Optional: hints
                        //self.hints = decodedResponse.hints.map{ $0.food }
                        
                        print("Decoded response successfully: \(self.foods)")
                    }
                } catch{
                    
                    //Handle Decoding Errors
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    
                    // Pretty-print JSON for debugging purposes
                    if let jsonObject = try? JSONSerialization.jsonObject(with: validData, options: []),
                       let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                       let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyPrintedString)")
                    }
                    else {
                        print("Unable to format JSON.")
                    }
                    
                    // Print out the raw response in case JSON couldn't be decoded
                    print(String(data: validData, encoding: .utf8) ?? "Unable to convert data to string for debugging.")
                }
            }
            
            // Start The Task
            task.resume()
        }
    }
}

//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
             
              
           


