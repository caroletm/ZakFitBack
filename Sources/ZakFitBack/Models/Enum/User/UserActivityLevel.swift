//
//  UserPreferences.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

enum UserActivityLevel: String, Codable, CaseIterable, Sendable {
    case parDefault
    case low
    case moderate
    case high
    case veryHigh
}
