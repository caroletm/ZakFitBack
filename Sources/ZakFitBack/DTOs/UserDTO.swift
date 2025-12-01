//
//  UserDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct UserCreateDTO: Content {
    var image: String
    var username: String
    var email: String
    var motDePasse: String
    var nom: String
    var prenom: String
    var taille: Int
    var poids: Double
    var dateNaissance: Date
    var sexe: UserGender
    var foodPreferences: UserPreferences
    var activityLevel: UserActivityLevel
}

// DTO public (informations non sensibles)
struct UserPublicDTO: Content {
    var id: UUID?
    var image: String
    var username: String
    var email: String
    var nom: String
    var prenom: String
}

// DTO santé (informations sensibles, accès JWT uniquement)
struct UserHealthDTO: Content {
    var id: UUID?
    var taille: Int
    var poids: Double
    var sexe: UserGender
    var dateNaissance: Date
    var foodPreferences: UserPreferences
    var activityLevel: UserActivityLevel
}

struct UserUpdateDTO : Content {
    var image : String?
    var username : String?
    var email : String?
    var motDePasse : String?
    var nom : String?
    var prenom : String?
    var taille : Int?
    var poids : Double?
    var sexe : UserGender?
    var dateNaissance : Date?
    var foodPreferences : UserPreferences?
    var activityLevel : UserActivityLevel?
}
