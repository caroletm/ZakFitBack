//
//  CreateRepas.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct CreateRepas: AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        let TypeRepas = try await db.enum("TypeRepas")
            .case("petitDejeuner")
            .case("dejeuner")
            .case("diner")
            .case("encas")
            .create()
        
        try await db.schema("Repas")
            .id()
            .field("typeRepas", TypeRepas, .required)
            .field("date", .datetime, .required)
            .field( "calories", .double, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Repas").delete()
        try await db.enum("TypeObjectif").delete()
    }
}
