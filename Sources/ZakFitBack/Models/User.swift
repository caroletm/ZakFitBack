//
//  User.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Vapor
import Fluent

final class User : Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id) var id : UUID?
    @Field(key: "image") var image: String
    @Field(key: "username") var username: String
    @Field(key: "email") var email: String
    @Field(key: "motDePasse") var motDePasse: String
    @Field(key: "nom") var nom: String
    @Field(key: "prenom") var prenom: String
    @Field(key: "taille") var taille: Int
    @Field(key: "poids") var Int: Double
    @Field(key: "dateNaissance") var dateNaissance: Date
    @Enum(key: "sexe") var sexe: UserGender
    @Enum(key: "foodPreferences") var foodPreferences: UserPreferences
    @Enum(key: "activityLevel") var activityLevel: UserActivityLevel
    @Enum(key: "role") var role: UserRole
    @Children(for : \.$user) var objectifs: [Objectif]
    @Children(for : \.$user) var activites: [Activite]
    @Children(for : \.$user) var repas: [Repas]
    
    
    init() {}
    
    init(id: UUID? = nil, image: String, username: String, email: String, motDePasse: String, nom: String, prenom: String, taille: Int, poids: Double, dateNaissance: Date, sexe: UserGender, foodPreferences: UserPreferences, activityLevel: UserActivityLevel, role: UserRole) {
        self.id = id ?? UUID()
        self.image = image
        self.username = username
        self.email = email
        self.motDePasse = motDePasse
        self.nom = nom
        self.prenom = prenom
        self.taille = taille
        self.Int = poids
        self.dateNaissance = dateNaissance
        self.sexe = sexe
        self.foodPreferences = foodPreferences
        self.activityLevel = activityLevel
        self.role = role
    }
}


