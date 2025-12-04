//
//  RepasController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor
import Fluent

struct RepasController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let repas = routes.grouped("repas")
        
        let protectedRoutes = repas.grouped(JWTMiddleware())
        protectedRoutes.get(use: getAllRepas)
        protectedRoutes.post(use: createRepas)
        
        protectedRoutes.group(":id") { repas in
            repas.get(use: getRepasById)
            repas.delete(use: deleteRepasById)
        }
    }

    //GET
    @Sendable
    func getAllRepas(_ req: Request) async throws -> [RepasDTO] {
        
        let payload = try req.auth.require(UserPayload.self)
        let userId = payload.id
        
        let repas = try await Repas.query(on: req.db)
            .filter(\.$user.$id == userId)
            .with(\.$consos)
            .all()

        return repas.map { repas in
            RepasDTO(
                id: repas.id,
                typeRepas: repas.typeRepas,
                date: repas.date,
                calories: repas.calories,
                consos: repas.consos.map { conso in
                    ConsoDTO(
                        id: conso.id,
                        aliment: conso.aliment,
                        portion: conso.portion,
                        quantite: conso.quantite,
                        calories: conso.calories,
                        proteines: conso.proteines,
                        glucides: conso.glucides,
                        lipides: conso.lipides
                    )
                }
            )
        }
    }

    //GET BY ID
    @Sendable
    func getRepasById(_ req: Request) async throws -> Repas {
        
        let payload = try req.auth.require(UserPayload.self)
        let userId = payload.id
    
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
        
        guard let repas = try await Repas.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
        return repas
    }
    
    // POST /repas
    @Sendable
    func createRepas(_ req: Request) async throws -> RepasDTO {
        let dto = try req.content.decode(RepasDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        } //        filtrer par le token de l'utilisateur)
        
//        guard let user = try await User.query(on: req.db).first() else {
//            throw Abort(.notFound, reason: "Utilisateur introuvable")
//        } //sans token
        
        let repas = Repas(
            id: UUID(),
            typeRepas: dto.typeRepas,
            date: dto.date,
            calories: dto.calories,
            user_Id : user.id!
        )
        try await repas.save(on: req.db)

           // Créer chaque conso à partir de dto.consos
        for consoDTO in dto.consos {
            guard let aliment = try await Aliment.query(on: req.db)
                .filter(\.$nom == consoDTO.aliment)
                .first() else {
                throw Abort(.notFound, reason: "Aliment \(consoDTO.aliment) introuvable")
            }
            
            let conso = Conso(
                id: UUID(),
                aliment: consoDTO.aliment,
                portion: consoDTO.portion,
                quantite: consoDTO.quantite,
                calories: consoDTO.calories,
                proteines: consoDTO.proteines,
                glucides: consoDTO.glucides,
                lipides: consoDTO.lipides,
                repas_Id: repas.id!,
                aliment_Id: aliment.id!
            )
            
            try await conso.save(on: req.db)
        }
        
        try await repas.$consos.load(on: req.db)
        
        return  RepasDTO(
            id: repas.id,
            typeRepas: repas.typeRepas,
            date: repas.date,
            calories: repas.calories,
            consos: repas.consos.map { conso in
                ConsoDTO(
                    id: conso.id,
                    aliment: conso.aliment,
                    portion: conso.portion,
                    quantite: conso.quantite,
                    calories: conso.calories,
                    proteines: conso.proteines,
                    glucides: conso.glucides,
                    lipides: conso.lipides
                )
            }
        )
    }
    
    //DELETE/repas/:id
    @Sendable
    func deleteRepasById(_ req: Request) async throws -> Response {
        
        let payload = try req.auth.require(UserPayload.self)
        
        let userId = payload.id
    
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
    
        guard let repas = try await Repas.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
        try await repas.delete(on: req.db)
        return Response(status: .noContent)
    }
}
