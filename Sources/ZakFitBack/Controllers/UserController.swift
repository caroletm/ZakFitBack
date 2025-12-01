//
//  UserController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Fluent
import Vapor

struct UserController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: getAllUsers)
        users.post(use: createUser)
        
        users.group(":id") { user in
            user.get(use: getUserById)
            user.delete(use: deleteUserById)
            user.patch(use: updateUserById)
        }
    }
    
    //GET
    @Sendable
    func getAllUsers(_ req: Request) async throws -> [UserDTO] {
        let user = try await User.query(on: req.db).all()
        return user.map { UserDTO(id: $0.id, image: $0.image, username: $0.username, email: $0.email, motDePasse: $0.motDePasse, nom: $0.nom, prenom: $0.prenom, taille: $0.taille, poids: $0.poids, sexe: $0.sexe, dateNaissance: $0.dateNaissance, foodPreferences: $0.foodPreferences, activityLevel: $0.activityLevel)}
    }
    
    //GET BY ID
    @Sendable
    func getUserById(_ req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }
    
    
    // POST /users
    @Sendable
    func createUser(_ req: Request) async throws -> UserDTO {
        let dto = try req.content.decode(UserDTO.self)
        
        if try await User.query(on: req.db)
            .filter(\.$email == dto.email)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un utilisateur avec cet email existe déjà")
        }
        
        let user = User(
            id: UUID(),
            image : dto.image,
            username : dto.username,
            email : dto.email,
            motDePasse : dto.motDePasse,
            nom : dto.nom,
            prenom : dto.prenom,
            taille : dto.taille,
            poids : dto.poids,
            dateNaissance : dto.dateNaissance,
            sexe : dto.sexe,
            foodPreferences : dto.foodPreferences,
            activityLevel : dto.activityLevel,
            role: .user
        )
        
        try await user.save(on: req.db)
        
        return UserDTO(
            id: user.id,
            image : user.image,
            username : user.username,
            email : user.email,
            motDePasse : user.motDePasse,
            nom : user.nom,
            prenom : user.prenom,
            taille : user.taille,
            poids : user.poids,
            sexe : user.sexe,
            dateNaissance : user.dateNaissance,
            foodPreferences : user.foodPreferences,
            activityLevel : user.activityLevel
        )
    }
    
    //DELETE/users/:id
    @Sendable
    func deleteUserById(_ req: Request) async throws -> Response {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest, reason: "Id invalide")
        }
        try await user.delete(on: req.db)
        return Response(status: .noContent)
    }
    
    //PATCH/users/:id
    @Sendable
    func updateUserById(_ req: Request) async throws -> UserDTO {
        let dto = try req.content.decode(UserUpdateDTO.self)
        
        guard let id = req.parameters.get("id", as: UUID.self),
              let user = try await User.find(id, on: req.db)
        else {
            throw Abort(.notFound)
        }
        
        if let newEmail = dto.email {
            if try await User.query(on: req.db)
                .filter(\.$email == newEmail)
                .filter(\.$id != id)   // exclure l'utilisateur lui-même
                .first() != nil {
                throw Abort(.badRequest, reason: "Cet email est déjà utilisé.")
            }
        }
        
        if let newUsername = dto.username {
            if try await User.query(on: req.db)
                .filter(\.$username == newUsername)
                .filter(\.$id != id)
                .first() != nil {
                throw Abort(.badRequest, reason: "Ce nom d'utilisateur est déjà utilisé.")
            }
        }
        
        if let v = dto.image { user.image = v }
        if let v = dto.username { user.username = v }
        if let v = dto.email { user.email = v }
        if let v = dto.motDePasse { user.motDePasse = v }
        if let v = dto.nom { user.nom = v }
        if let v = dto.prenom { user.prenom = v }
        if let v = dto.taille { user.taille = v }
        if let v = dto.poids { user.poids = v }
        if let v = dto.sexe { user.sexe = v }
        if let v = dto.dateNaissance { user.dateNaissance = v }
        if let v = dto.foodPreferences { user.foodPreferences = v }
        if let v = dto.activityLevel { user.activityLevel = v }
        
        try await user.save(on: req.db)
        
        return UserDTO(
            id: user.id,
            image : user.image,
            username : user.username,
            email : user.email,
            motDePasse : user.motDePasse,
            nom : user.nom,
            prenom : user.prenom,
            taille : user.taille,
            poids : user.poids,
            sexe : user.sexe,
            dateNaissance : user.dateNaissance,
            foodPreferences : user.foodPreferences,
            activityLevel : user.activityLevel
        )
    }
}
