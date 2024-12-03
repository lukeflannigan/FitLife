import Foundation

struct FatSecretFood: Codable {
    let food_id: String
    let food_name: String
    let brand_name: String?
    let servings: ServingContainer?
    
    var foodId: String { food_id }
    var foodName: String { food_name }
    var brandName: String? { brand_name }
    
    struct ServingContainer: Codable {
        let serving: [Serving]
    }
    
    struct Serving: Codable, Hashable {
        let serving_id: String
        let serving_description: String
        let serving_url: String
        let metric_serving_amount: String?
        let metric_serving_unit: String?
        let number_of_units: String?
        let measurement_description: String
        let calories: String
        let protein: String
        let carbohydrate: String
        let fat: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(serving_id)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.serving_id == rhs.serving_id
        }
    }
}

extension FatSecretFood.Serving {
    var servingDescription: String { serving_description }
    var caloriesInt: Int { Int(calories) ?? 0 }
    var proteinDouble: Double { Double(protein) ?? 0 }
    var carbsDouble: Double { Double(carbohydrate) ?? 0 }
    var fatDouble: Double { Double(fat) ?? 0 }
}

actor FatSecretService {
    static let shared = FatSecretService()
    
    private let baseURL = "https://platform.fatsecret.com/rest/server.api"
    private let tokenURL = "https://oauth.fatsecret.com/connect/token"
    private let clientId = AppConfiguration.fatSecretClientId
    private let clientSecret = AppConfiguration.fatSecretClientSecret
    
    private var accessToken: String?
    private var tokenExpirationDate: Date?
    
    private init() {}
    
    private func getAccessToken() async throws -> String {
        if let token = accessToken, 
           let expirationDate = tokenExpirationDate, 
           expirationDate > Date() {
            return token
        }
        
        let credentials = "\(clientId):\(clientSecret)"
            .data(using: .utf8)!
            .base64EncodedString()
        
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&scope=basic".data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        accessToken = tokenResponse.accessToken
        tokenExpirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
        
        return tokenResponse.accessToken
    }
    
    func searchFoods(query: String) async throws -> [FatSecretFood] {
        let token = try await getAccessToken()
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "method", value: "foods.search"),
            URLQueryItem(name: "search_expression", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "max_results", value: "50")
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchResponse.foods?.food.map { $0.toFatSecretFood } ?? []
    }
    
    func getFoodDetails(id: String) async throws -> FatSecretFood {
        let token = try await getAccessToken()
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "method", value: "food.get"),
            URLQueryItem(name: "food_id", value: id),
            URLQueryItem(name: "format", value: "json")
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(FoodResponse.self, from: data)
        return response.food
    }
}

// MARK: - Error Handling
private enum APIError: LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "Server returned status code \(statusCode)"
        }
    }
}

// MARK: - Response Types
private struct TokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}

private struct SearchResponse: Codable {
    let foods: Foods?
    
    struct Foods: Codable {
        let food: [FoodResult]
        
        private enum CodingKeys: String, CodingKey {
            case food
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let singleFood = try? container.decode(FoodResult.self, forKey: .food) {
                self.food = [singleFood]
            } else {
                self.food = try container.decode([FoodResult].self, forKey: .food)
            }
        }
    }
    
    struct FoodResult: Codable {
        let food_id: String
        let food_name: String
        let brand_name: String?
        let servings: FatSecretFood.ServingContainer?
        
        var toFatSecretFood: FatSecretFood {
            FatSecretFood(
                food_id: food_id,
                food_name: food_name,
                brand_name: brand_name,
                servings: servings
            )
        }
    }
}

private struct FoodResponse: Codable {
    let food: FatSecretFood
}

// MARK: - Model Conversion
extension FatSecretFood {
    func toFoodItem() -> FoodItem {
        guard let firstServing = servings?.serving.first else {
            return FoodItem(
                name: foodName,
                brandName: brandName,
                servingSize: "1 serving",
                servingSizeGrams: 0,
                calories: 0,
                protein: 0,
                carbs: 0,
                fat: 0,
                fatSecretId: foodId
            )
        }
        
        return FoodItem(
            name: foodName,
            brandName: brandName,
            servingSize: firstServing.serving_description,
            servingSizeGrams: Double(firstServing.metric_serving_amount ?? "0") ?? 0,
            calories: firstServing.caloriesInt,
            protein: firstServing.proteinDouble,
            carbs: firstServing.carbsDouble,
            fat: firstServing.fatDouble,
            fatSecretId: foodId
        )
    }
}
