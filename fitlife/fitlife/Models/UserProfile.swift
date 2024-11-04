//
//  UserProfile.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/22/24.
//

import Foundation
import SwiftData

@Model
class UserProfile {
    typealias LocaleIdentifier = String
    private(set) var localeIdentifier: LocaleIdentifier
    var locale: Locale {
        get { Locale(identifier: localeIdentifier) }
        set { localeIdentifier = newValue.identifier }
    }
    
    var name: String
    var heightInCm: Double
    var age: Int
    var gender: String
    var isMetric: Bool // Tracks if the user prefers metric or imperial
    var userGoals: UserGoals?

    init(name: String, age: Int , heightInCm: Double, gender: String, localeIdentifier: String = Locale.autoupdatingCurrent.identifier, isMetric: Bool) {
        self.name = name
        self.age = age
        self.heightInCm = heightInCm
        self.gender = gender
        self.localeIdentifier = localeIdentifier
        self.isMetric = isMetric
    }
    
    
    // Convert height to imperial if needed
    func heightInFeetAndInches() -> (feet: Int, inches: Int) {
        let totalInches = heightInCm / 2.54
        let feet = Int(totalInches / 12)
        let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
        return (feet, inches)
    }

    // Set height based on feet and inches if using imperial units
    func setHeightFromImperial(feet: Int, inches: Int) {
        heightInCm = Double(feet * 12 + inches) * 2.54
    }
}

//extension UserProfile {
//    static var mockUserProfile = UserProfile(
//        name: "Ted",
//        age: 20,
//        heightInCm: 170,
//        gender: "male",
//        localeIdentifier: Locale.autoupdatingCurrent.identifier,
//        isMetric: true,
//        userGoals: userGoals
//    )
//}
