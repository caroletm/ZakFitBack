//
//  CreateActivite.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct CreateActivite: AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        let TypeActivite = try await db.enum("TypeActivite")
            .case("courseAPied")
            .case("musculation")
            .case("velo")
            .case("yoga")
            .case("tennis")
            .case("danse")
            .case("basket")
            .case("marche")
            .case("natation")
            .case("football")
            .create()
        
        try await db.schema("Activite")
            .id()
            .field("typeActivite", TypeActivite, .required)
            .field("date", .datetime, .required)
            .field("duree", .int, .required)
            .field("caloriesBrulees", .double, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Activite").delete()
        try await db.enum("TypeObjectif").delete()
    }
}
