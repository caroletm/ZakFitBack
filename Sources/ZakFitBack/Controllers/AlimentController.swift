//
//  AlimentController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor
import Fluent

struct AlimentController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let aliment = routes.grouped("aliment")
        aliment.get(use: getAllAliments)
        aliment.post(use: createAliment)
        
        aliment.group(":id") { aliment in
            aliment.get(use: getAlimentById)
            aliment.delete(use: deleteAlimentById)
        }
    }
    
    //    GET
    @Sendable
    func getAllAliments(_ req: Request) async throws -> [AlimentDTO] {
        let aliment = try await Aliment.query(on: req.db).all()
        return aliment.map { AlimentDTO( id: $0.id, nom: $0.nom, portion: $0.portion, calories: $0.calories, proteines: $0.proteines, glucides: $0.glucides, lipides: $0.lipides)
        }
    }
    
    //GET BY ID
    @Sendable
    func getAlimentById(_ req: Request) async throws -> Aliment {
        guard let aliment = try await Aliment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return aliment
    }
    
    // POST /aliment
    @Sendable
    func createAliment(_ req: Request) async throws -> AlimentDTO {
        let dto = try req.content.decode(AlimentDTO.self)
        
        let aliment = Aliment(
            id: UUID(),
            nom : dto.nom,
            portion : dto.portion,
            calories : dto.calories,
            proteines : dto.proteines,
            glucides : dto.glucides,
            lipides : dto.lipides
        )
        
        try await aliment.save(on: req.db)
        
        return AlimentDTO(
            id: aliment.id,
            nom : aliment.nom,
            portion : aliment.portion,
            calories : aliment.calories,
            proteines : aliment.proteines,
            glucides : aliment.glucides,
            lipides : aliment.lipides
        )
    }
    
    //DELETE/aliment/:id
    @Sendable
    func deleteAlimentById(_ req: Request) async throws -> Response {
        guard let activite = try await Activite.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest, reason: "Id invalide")
        }
        try await activite.delete(on: req.db)
        return Response(status: .noContent)
    }
}
