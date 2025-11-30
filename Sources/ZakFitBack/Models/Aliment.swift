//
//  Repas.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Vapor
import Fluent

final class Aliment : Model, Content, @unchecked Sendable {
    static let schema = "Aliment"
    
    @ID(key: .id) var id : UUID?
    @Field(key: "nom") var nom: String
    @Enum(key: "portion") var portion: Portion
    @Field(key: "calories") var calories: Double
    @Field(key: "proteines") var proteines: Double
    @Field(key: "glucides") var glucides: Double
    @Field(key: "lipides") var lipides: Double
    @Children(for : \.$aliments) var consos: [Conso]
    
    init() {}
    
    init(id: UUID? = nil, nom: String, portion: Portion, calories: Double, proteines: Double, glucides: Double, lipides: Double) {
        self.id = id ?? UUID()
        self.nom = nom
        self.portion = portion
        self.calories = calories
        self.proteines = proteines
        self.glucides = glucides
        self.lipides = lipides
    }

}
