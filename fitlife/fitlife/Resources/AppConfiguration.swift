import Foundation

enum AppConfiguration {
    private static let plist: [String: Any] = {
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: plistPath) as? [String: Any] else {
            fatalError("Failed to load Config.plist")
        }
        return plist
    }()
    
    static var fatSecretClientId: String {
        guard let clientId = plist["FatSecretClientId"] as? String else {
            fatalError("FatSecretClientId not found in Config.plist")
        }
        return clientId
    }
    
    static var fatSecretClientSecret: String {
        guard let clientSecret = plist["FatSecretClientSecret"] as? String else {
            fatalError("FatSecretClientSecret not found in Config.plist")
        }
        return clientSecret
    }
}