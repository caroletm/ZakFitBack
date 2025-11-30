//
//  UpdateRepas.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct UpdateRepas: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Repas")
            .field("user_id", .uuid, .required,
                .references("users", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Repas")
            .deleteField("user_id")
            .update()
    }
}
