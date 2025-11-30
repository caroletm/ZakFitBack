//
//  CreateUser.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
     
        let UserGender = try await db.enum("UserGender")
            .case("male")
            .case("female")
            .case("other")
            .create()
        
        let UserPreferences = try await db.enum("UserPreferences")
            .case("parDefault")
            .case("vegetarian")
            .case("vegan")
            .case("glutenFree")
            .case( "lactoseIntolerant")
            .create()
        
        let UserActivityLevel = try await db.enum("UserActivityLevel")
            .case("parDefault")
            .case("low")
            .case("moderate")
            .case("high")
            .case( "veryHigh")
            .create()
        
        let UserRole = try await db.enum("UserRole")
            .case("parDefault")
            .case("user")
            .case("admin")
            .create()
        
        try await db.schema("users")
            .id()
            .field("image", .string, .required)
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("motDePasse", .string, .required)
            .field("nom", .string, .required)
            .field("prenom", .string, .required)
            .field("taille", .int, .required)
            .field("poids", .double, .required)
            .field("dateNaissance", .date, .required)
            .field("sexe", UserGender, .required)
            .field("foodPreferences", UserPreferences, .required)
            .field("activityLevel", UserActivityLevel, .required)
            .field("role", UserRole, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users").delete()
        try await db.enum("UserPreferences").delete()
        try await db.enum("UserActivityLevel").delete()
        try await db.enum("UserRole").delete()
    }
}
