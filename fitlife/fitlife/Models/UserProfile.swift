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

    init(name: String = "", age: Int = 0, heightInCm: Double = 0, gender: String = "", localeIdentifier: String = Locale.autoupdatingCurrent.identifier, isMetric: Bool = true) {
            self.name = name
            self.age = age
            self.heightInCm = heightInCm
            self.gender = gender
            self.localeIdentifier = localeIdentifier
            self.isMetric = isMetric
        }
    
}
