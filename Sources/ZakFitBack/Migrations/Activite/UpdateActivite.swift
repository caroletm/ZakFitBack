//
//  UpdateActivite.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct UpdateActivite: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Activite")
            .field("user_id", .uuid, .required,
                .references("users", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Activite")
            .deleteField("user_id")
            .update()
    }
}
