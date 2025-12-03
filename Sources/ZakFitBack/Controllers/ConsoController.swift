//
//  ConsoController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor
import Fluent

struct ConsoController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let conso = routes.grouped("conso")
        conso.get(use: getAllConsos)
        conso.get(use: getConsoById)
        conso.grouped(":id").delete(use: getConsoById)
        
    }
    
    //    GET
    @Sendable
    func getAllConsos(_ req: Request) async throws -> [ConsoDTO] {
        let conso = try await Conso.query(on: req.db).all()
        return conso.map { ConsoDTO(id: $0.id, aliment: $0.aliment, portion: $0.portion, quantite: $0.quantite, calories: $0.calories, glucides: $0.glucides, proteines: $0.proteines, lipides: $0.lipides)}
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
