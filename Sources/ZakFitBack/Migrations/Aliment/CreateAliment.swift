//
//  CreateAliment.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct CreateAliment: AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        let Portion = try await db.enum("Portion")
            .case("parDefault")
            .case("unite")
            .case("cuillere")
            .case("verre")
            .case("tasse")
            .case("tranche")
            .case("gramme")
            .case("kilo")
            .case("litre")
            .case("mililitre")
            .create()
        
        try await db.schema("Aliment")
            .id()
            .field("nom", .string, .required)
            .field("portion", Portion, .required)
            .field("calories", .double, .required)
            .field("proteines", .double, .required)
            .field("glucides", .double, .required)
            .field("lipides", .double, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Aliment").delete()
        try await db.enum("Portion").delete()
    }
}
