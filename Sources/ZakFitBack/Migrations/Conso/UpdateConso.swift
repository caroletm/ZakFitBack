//
//  UpdateConso.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct UpdateConsoFKeyRepas: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Conso")
            .field("repas_id", .uuid, .required,
                .references("Repas", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Conso")
            .deleteField("repas_id")
            .update()
    }
}

struct UpdateConsoFKeyAliment: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Conso")
            .field("aliment_id", .uuid, .required,
                .references("Aliment", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Conso")
            .deleteField("aliment_id")
            .update()
    }
}

struct UpdateConsoQuantite: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Conso")
            .field("quantite", .int, .required)
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Conso")
            .deleteField("quantite")
            .update()
    }
}
