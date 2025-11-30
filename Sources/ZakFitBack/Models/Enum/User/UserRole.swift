//
//  UserRole.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

enum UserRole: String, Codable, CaseIterable, Sendable {
    case user
    case admin
}
