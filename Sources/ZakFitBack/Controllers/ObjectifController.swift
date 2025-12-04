//
//  ObjectifController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Fluent
import Vapor

struct ObjectifController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let objectif = routes.grouped("objectif")
        
        let protectedRoute = objectif.grouped(JWTMiddleware())
        
        protectedRoute.get(use: getAllObjectifs)
        protectedRoute.post(use: createObjectif)
        
        protectedRoute.group(":id") { objectif in
            objectif.get(use: getObjectifById)
            objectif.patch(use: updateObjectifById)
            objectif.delete(use: deleteObjectifById)
        }
    }
    
    
    //GET
    @Sendable
    func getAllObjectifs(_ req: Request) async throws -> [ObjectifDTO] {
        
        let payload = try req.auth.require(UserPayload.self)
        let userId = payload.id
        
        let objectifs = try await Objectif.query(on: req.db)
            .filter(\.$user.$id == userId)
            .all()

        return objectifs.map { ObjectifDTO(id: $0.id, objectifGlobal: $0.objectifGlobal, dateDebut: $0.dateDebut, dateFin: $0.dateFin, typeObjectif: $0.typeObjectif, poidsCible: $0.poidsCible, caloriesParJour: $0.caloriesParJour, proteines: $0.proteines, glucides: $0.glucides, lipides: $0.lipides, minsActivité: $0.minsActivité, caloriesBruleesParJour: $0.caloriesBruleesParJour, nbEntrainementsHebdo: $0.nbEntrainementsHebdo) }
    }
    
    
    //GET BY ID
    @Sendable
    func getObjectifById(_ req: Request) async throws -> Objectif {
        
        let payload = try req.auth.require(UserPayload.self)
        let userId = payload.id
    
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
    
        guard let objectif = try await Objectif.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
//        guard let objectif = try await Objectif.find(req.parameters.get("id"), on: req.db) else {
//            throw Abort(.notFound)
//        }
        return objectif
    }
    
//
    
    // POST /objectif
    @Sendable
    func createObjectif(_ req: Request) async throws -> ObjectifDTO {
        let dto = try req.content.decode(ObjectifDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        } //        filtrer par le token de l'utilisateur)
        
        
        //        guard let user = try await User.query(on: req.db).first() else {
        //            throw Abort(.notFound, reason: "Utilisateur introuvable")
        //        }
        //            //sans token
        
        let objectif = Objectif(
            id: UUID(),
            objectifGlobal: dto.objectifGlobal,
            dateDebut: dto.dateDebut,
            dateFin: dto.dateFin,
            typeObjectif : dto.typeObjectif,
            poidsCible: dto.poidsCible,
            caloriesParJour: dto.caloriesParJour,
            proteines : dto.proteines,
            glucides : dto.glucides,
            lipides : dto.lipides,
            minsActivité: dto.minsActivité,
            caloriesBruleesParJour: dto.caloriesBruleesParJour,
            nbEntrainementsHebdo: dto.nbEntrainementsHebdo,
            user_Id : user.id!
        )
        
        try await objectif.save(on: req.db)
        
        return ObjectifDTO(
            id: objectif.id,
            objectifGlobal: objectif.objectifGlobal,
            dateDebut: objectif.dateDebut,
            typeObjectif : objectif.typeObjectif,
            poidsCible: objectif.poidsCible,
            caloriesParJour: objectif.caloriesParJour,
            proteines : objectif.proteines,
            glucides : objectif.glucides,
            lipides : objectif.lipides,
            minsActivité: objectif.minsActivité,
            caloriesBruleesParJour: objectif.caloriesBruleesParJour,
            nbEntrainementsHebdo: objectif.nbEntrainementsHebdo
        )
    }
    
    //DELETE/objectif/:id
    @Sendable
    func deleteObjectifById(_ req: Request) async throws -> Response {
        
        let payload = try req.auth.require(UserPayload.self)
        
        let userId = payload.id
    
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
    
        guard let objectif = try await Objectif.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
        try await objectif.delete(on: req.db)
        
        return Response(status: .noContent)
    }
    
    
    //PATCH/objectif/:id
    @Sendable
    func updateObjectifById(_ req: Request) async throws -> ObjectifDTO {
        let dto = try req.content.decode(ObjectifUpdateDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        
        let userId = payload.id
    
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
    
        guard let objectif = try await Objectif.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
        if let v = dto.objectifGlobal { objectif.objectifGlobal = v }
        if let v = dto.dateDebut { objectif.dateDebut = v }
        if let v = dto.typeObjectif { objectif.typeObjectif = v }
        if let v = dto.poidsCible { objectif.poidsCible = v }
        if let v = dto.caloriesParJour { objectif.caloriesParJour = v }
        if let v = dto.proteines { objectif.proteines = v }
        if let v = dto.glucides { objectif.glucides = v }
        if let v = dto.lipides { objectif.lipides = v }
        if let v = dto.minsActivité { objectif.minsActivité = v }
        if let v = dto.caloriesBruleesParJour { objectif.caloriesBruleesParJour = v }
        if let v = dto.nbEntrainementsHebdo { objectif.nbEntrainementsHebdo = v }
        
        try await objectif.save(on: req.db)
        
        return  ObjectifDTO(
            id: objectif.id,
            objectifGlobal: objectif.objectifGlobal,
            dateDebut: objectif.dateDebut,
            typeObjectif : objectif.typeObjectif,
            poidsCible: objectif.poidsCible,
            caloriesParJour: objectif.caloriesParJour,
            proteines : objectif.proteines,
            glucides : objectif.glucides,
            lipides : objectif.lipides,
            minsActivité: objectif.minsActivité,
            caloriesBruleesParJour: objectif.caloriesBruleesParJour,
            nbEntrainementsHebdo: objectif.nbEntrainementsHebdo
        )
    }
}

