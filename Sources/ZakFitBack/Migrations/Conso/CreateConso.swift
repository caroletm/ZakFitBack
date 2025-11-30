//
//  CreateConso.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct CreateConso: AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        let Portion = try await db.enum("Portion").read()
        
        try await db.schema("Conso")
            .id()
            .field("aliment", .string, .required)
            .field("portion", Portion, .required)
            .field("calories", .double, .required)
            .field("proteines", .double, .required)
            .field("glucides", .double, .required)
            .field("lipides", .double, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Conso").delete()
 
    }
}
