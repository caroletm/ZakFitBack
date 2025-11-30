//
//  UserPreferences.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

enum UserPreferences: String, Codable, CaseIterable, Sendable {
    case parDefault
    case vegetarian
    case vegan
    case glutenFree
    case lactoseIntolerant
    case none
}
