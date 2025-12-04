//
//  ActiviteController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor
import Fluent

struct ActiviteController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let activite = routes.grouped("activite")
        
        let protectedRoutes = activite.grouped(JWTMiddleware())
        protectedRoutes.get(use: getAllActivites)  // GET /activite
        protectedRoutes.post(use: createActivite)  // POST /activite
        
        protectedRoutes.group(":id") { activiteId in
            activiteId.get(use: getActiviteById)
            activiteId.delete(use: deleteActiviteById)
        }
    }
    
    //GET/activite
    //Récupère toutes les activités du user (filtré par son token)
    @Sendable
    func getAllActivites(_ req: Request) async throws -> [ActiviteDTO] {
        
        let payload = try req.auth.require(UserPayload.self)
        let userId = payload.id
        
        let activite = try await Activite.query(on: req.db)
            .filter(\.$user.$id == userId)
            .all()
        
        return activite.map { ActiviteDTO(typeActivite: $0.typeActivite, date: $0.date, duree: $0.duree, caloriesBrulees: $0.caloriesBrulees)
        }
    }
    
    //GET/activite/id:
    //Récupère toutes les activités du user (filtré par son token) filtré par l'ID de l'activité
    @Sendable
    func getActiviteById(_ req: Request) async throws -> Activite {
        
        let payload = try req.auth.require(UserPayload.self)
        let userId = payload.id
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
        
        guard let activite = try await Activite.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
        return activite
    }
    
    //POST/activite/
    //Crée une activité pour le user (filtré par son token)
    @Sendable
    func createActivite(_ req: Request) async throws -> ActiviteDTO {
        let dto = try req.content.decode(ActiviteDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        //        filtrer par le token de l'utilisateur)
        
        let activite = Activite(
            id: UUID(),
            typeActivite: dto.typeActivite,
            date: dto.date,
            duree: dto.duree,
            caloriesBrulees: dto.caloriesBrulees,
            user_Id : user.id!
        )
        
        try await activite.save(on: req.db)
        
        return ActiviteDTO(
            id: activite.id,
            typeActivite: activite.typeActivite,
            date: activite.date,
            duree: activite.duree,
            caloriesBrulees: activite.caloriesBrulees
        )
    }
    
    //DELETE/activite/:id
    //Supprime une activité par l'id de l'activité
    @Sendable
    func deleteActiviteById(_ req: Request) async throws -> Response {
        
        let payload = try req.auth.require(UserPayload.self)
        
        let userId = payload.id
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide")
        }
        
        guard let activite = try await Activite.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound)
        }
        
        try await activite.delete(on: req.db)
        return Response(status: .noContent)
    }
    
    //    //PATCH/activite/:id
    //    @Sendable
    //    func updateActiviteById(_ req: Request) async throws -> ActiviteDTO {
    //        let dto = try req.content.decode(ActiviteUpdateDTO.self)
    //
    //        guard let id = req.parameters.get("id", as: UUID.self),
    //              let activite = try await Activite.find(id, on: req.db)
    //        else {
    //            throw Abort(.notFound)
    //        }
    //
    //        if let v = dto.typeActivite { activite.typeActivite = v }
    //        if let v = dto.date { activite.date = v }
    //        if let v = dto.duree { activite.duree = v }
    //        if let v = dto.caloriesBrulees { activite.caloriesBrulees = v }
    //
    //        try await activite.save(on: req.db)
    //
    //        return  ActiviteDTO(
    //            id: activite.id,
    //            typeActivite: activite.typeActivite,
    //            date: activite.date,
    //            duree: activite.duree,
    //            caloriesBrulees: activite.caloriesBrulees
    //        )
    //    }
}
