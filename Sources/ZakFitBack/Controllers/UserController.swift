//
//  UserController.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Fluent
import Vapor
import JWT

struct UserController : RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: getAllUsers)
        users.post(use: createUser)
        users.post("login", use: login)
        
        let protectedRoutes = users.grouped(JWTMiddleware())
        protectedRoutes.get("profile", use: profile)
        protectedRoutes.patch(":id", use: updateUserById)
        
        users.group(":id") { user in
            user.get(use: getUserById)
            user.delete(use: deleteUserById)
        }
    }
    
    //GET
    @Sendable
    func getAllUsers(_ req: Request) async throws -> [UserDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { user in
            UserDTO(
                id: user.id,
                image: user.image,
                username: user.username,
                email: user.email,
                nom: user.nom,
                prenom: user.prenom,
                taille: user.taille,
                poids: user.poids,
                sexe: user.sexe,
                dateNaissance: user.dateNaissance,
                foodPreferences: user.foodPreferences,
                activityLevel: user.activityLevel
            )
        }
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
        let dto = try req.content.decode(UserCreateDTO.self)
        
        if try await User.query(on: req.db)
            .filter(\.$email == dto.email)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un utilisateur avec cet email existe déjà")
        }
        
        if dto.motDePasse.count < 8 {
            throw Abort(.badRequest, reason: "Le mot de passe doit contenir au moins 8 caractères.")
        }
        let motDePasseHashed = try Bcrypt.hash(dto.motDePasse)
        
        let user = User(
            image: dto.image,
            username: dto.username,
            email: dto.email,
            motDePasse: motDePasseHashed,
            nom: dto.nom,
            prenom: dto.prenom,
            taille: dto.taille,
            poids: dto.poids,
            dateNaissance: dto.dateNaissance,
            sexe: dto.sexe,
            foodPreferences: dto.foodPreferences,
            activityLevel: dto.activityLevel,
            role: .user
        )
        
        try await user.save(on: req.db)
        
        return UserDTO(
            id: user.id,
            image: user.image,
            username: user.username,
            email: user.email,
            nom: user.nom,
            prenom: user.prenom,
            taille: user.taille,
            poids: user.poids,
            sexe: user.sexe,
            dateNaissance: user.dateNaissance,
            foodPreferences: user.foodPreferences,
            activityLevel: user.activityLevel
        )
    }
    
    // LOGIN
    struct LoginResponse: Content {
        let token: String
    }
    
    @Sendable
    func login(req: Request) async throws -> LoginResponse {
        let userData = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Email incorrect")
        }
        
        guard try Bcrypt.verify(userData.motDePasse, created: user.motDePasse) else {
            throw Abort(.unauthorized, reason: "Mot de passe incorrect")
        }
        
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "LOUVRE123")
        let token = try signer.sign(payload)
        return LoginResponse(token:token)
    }
    
    //PROFILE
    @Sendable
    func profile(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return UserDTO(
            id: user.id,
            image: user.image,
            username: user.username,
            email: user.email,
            nom: user.nom,
            prenom: user.prenom,
            taille: user.taille,
            poids: user.poids,
            sexe: user.sexe,
            dateNaissance: user.dateNaissance,
            foodPreferences: user.foodPreferences,
            activityLevel: user.activityLevel
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
        print("DTO reçu :", dto)
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let idParam = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID utilisateur manquant")
        }
        
        guard idParam == payload.id else {
            throw Abort(.forbidden, reason: "Vous pouvez modifier que votre profil")
        }
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        
        if let newEmail = dto.email {
            if try await User.query(on: req.db)
                .filter(\.$email == newEmail)
                .filter(\.$id != user.id!)
                .first() != nil {
                throw Abort(.badRequest, reason: "Cet email est déjà utilisé.")
            }
        }
        
        if let newUsername = dto.username {
            if try await User.query(on: req.db)
                .filter(\.$username == newUsername)
                .filter(\.$id != user.id!)
                .first() != nil {
                throw Abort(.badRequest, reason: "Ce nom d'utilisateur est déjà utilisé.")
            }
        }
        
        if let newPassword = dto.motDePasse {
            guard newPassword.count >= 8 else {
                throw Abort(.badRequest, reason: "Le mot de passe doit contenir au moins 8 caractères.")
            }
            user.motDePasse = try Bcrypt.hash(newPassword)
        }
        
        // Mise à jour des autres champs
            if let image = dto.image { user.image = image }
            if let nom = dto.nom { user.nom = nom }
            if let prenom = dto.prenom { user.prenom = prenom }
            if let taille = dto.taille { user.taille = taille }
            if let poids = dto.poids { user.poids = poids }
            if let sexe = dto.sexe { user.sexe = sexe }
            if let dateNaissance = dto.dateNaissance { user.dateNaissance = dateNaissance }
            if let foodPreferences = dto.foodPreferences { user.foodPreferences = foodPreferences }
            if let activityLevel = dto.activityLevel { user.activityLevel = activityLevel }
            
        print("User avant save :", user)
        try await user.save(on: req.db)
        
        return UserDTO(
            id: user.id,
            image: user.image,
            username: user.username,
            email: user.email,
            nom: user.nom,
            prenom: user.prenom,
            taille: user.taille,
            poids: user.poids,
            sexe: user.sexe,
            dateNaissance: user.dateNaissance,
            foodPreferences: user.foodPreferences,
            activityLevel: user.activityLevel
        )
    }
}
   
