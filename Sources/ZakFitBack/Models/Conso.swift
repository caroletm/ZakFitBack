//
//  Conso.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Vapor
import Fluent

final class Conso : Model, Content, @unchecked Sendable {
    static let schema = "Conso"
    
    @ID(key: .id) var id : UUID?
    @Field(key: "aliment") var aliment : String
    @Enum(key: "portion") var portion: Portion
    @Field(key: "quantite") var quantite: Int
    @Field(key: "calories") var calories: Double
    @Field(key: "proteines") var proteines: Double
    @Field(key: "glucides") var glucides: Double
    @Field(key: "lipides") var lipides: Double
    @Parent(key: "repas_Id") var repas: Repas
    @Parent(key: "aliment_Id") var aliments: Aliment
    
    init() {}
    init(id : UUID? = nil, aliment : String, portion: Portion, quantite: Int, calories: Double, proteines: Double, glucides: Double, lipides: Double, repas_Id: Repas.IDValue, aliment_Id: Aliment.IDValue) {
        self.id = id ?? UUID()
        self.aliment = aliment
        self.portion = portion
        self.quantite = quantite
        self.calories = calories
        self.proteines = proteines
        self.glucides = glucides
        self.lipides = lipides
        self.$repas.id = repas_Id
        self.$aliments.id = aliment_Id
    }

}
