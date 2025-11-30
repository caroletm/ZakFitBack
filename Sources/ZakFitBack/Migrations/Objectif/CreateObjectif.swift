//
//  CreateObjectif.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Fluent

struct CreateObjectif: AsyncMigration {
    func prepare(on db: any Database) async throws {
     
        let UserObjectifGlobal = try await db.enum("UserObjectifGlobal")
            .case("parDefault")
            .case("perte")
            .case("gain")
            .case("maintien")
            .create()
        
        let TypeObjectif = try await db.enum("TypeObjectif")
            .case("repas")
            .case("activite")
            .create()
        
        try await db.schema("Objectif")
            .id()
            .field("objectifGlobal", UserObjectifGlobal, .required)
            .field("dateDebut", .date, .required)
            .field("dateFin", .date)
            .field("typeObjectif", TypeObjectif, .required)
            .field("poidsCible", .double)
            .field("caloriesParJour", .double)
            .field("proteines", .double)
            .field("glucides", .double)
            .field("lipides", .double)
            .field("minsActivité", .int)
            .field("caloriesBruleesParJour", .double)
            .field("nbEntrainementsHebdo", .int)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Objectif").delete()
        try await db.enum("UserObjectifGlobal").delete()
        try await db.enum("TypeObjectif").delete()
    }
}
