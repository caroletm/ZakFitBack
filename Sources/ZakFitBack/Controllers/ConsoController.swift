//
//  ConsoController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor
import Fluent
import SQLKit

struct ConsoController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
            let conso = routes.grouped("conso")
            
            conso.get(use: getAllConsos)
        conso.delete(use: deleteAllConsos)
            conso.group(":id") { route in
                route.get(use: getConsoById)
                route.delete(use: deleteConsoById)
            }
        }
    
    //    GET
    @Sendable
    func getAllConsos(_ req: Request) async throws -> [ConsoDTO] {
        let conso = try await Conso.query(on: req.db).all()
        return conso.map { ConsoDTO(id: $0.id, aliment: $0.aliment, portion: $0.portion, quantite: $0.quantite, calories: $0.calories, proteines: $0.proteines, glucides: $0.glucides,  lipides: $0.lipides)}
    }
    
    //GET BY ID
    @Sendable
    func getConsoById(_ req: Request) async throws -> Conso {
        guard let conso = try await Conso.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return conso
    }
}

//    //DELETE/conso/:id
@Sendable
func deleteConsoById(_ req: Request) async throws -> Response {
    
    guard let conso = try await Conso.find(req.parameters.get("id"), on: req.db) else {
        throw Abort(.badRequest, reason: "Id invalide")
    }
    try await conso.delete(on: req.db)
    return Response(status: .noContent)
}
    
@Sendable
func deleteAllConsos(_ req: Request) async throws -> Response {

    let sql = req.db as! (any SQLDatabase)

        try await sql.raw("DELETE FROM Conso").run()

        return Response(status: .noContent)
    }
    
