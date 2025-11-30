//
//  Objectif.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Vapor
import Fluent

final class Objectif : Model, Content, @unchecked Sendable {
    static let schema = "Objectif"
    
    @ID(key: .id) var id : UUID?
    @Enum(key: "objectifGlobal") var objectifGlobal: UserObjectifGlobal
    @Field(key: "dateDebut") var dateDebut: Date
    @Timestamp(key: "dateFin", on: .update) var dateFin: Date?
    @Enum(key: "typeObjectif") var typeObjectif: TypeObjectif
    @Field(key: "poidsCible") var poidsCible: Double?
    @Field(key: "caloriesParJour") var caloriesParJour: Double?
    @Field(key: "proteines") var proteines: Double?
    @Field(key: "glucides") var glucides: Double?
    @Field(key: "lipides") var lipides: Double?
    @Field(key: "minsActivité") var minsActivité : Int?
    @Field(key: "caloriesBruleesParJour") var caloriesBruleesParJour: Double?
    @Field(key: "nbEntrainementsHebdo") var nbEntrainementsHebdo: Int?
    @Parent(key: "user_Id") var user: User
    
    init() {}
    init(id: UUID? = nil, objectifGlobal: UserObjectifGlobal, dateDebut: Date, typeObjectif: TypeObjectif, poidsCible: Double?, caloriesParJour: Double?, proteines: Double?, glucides: Double?, lipides: Double?, minsActivité: Int?, caloriesBruleesParJour: Double?, nbEntrainementsHebdo: Int?) {
        
        self.id = id ?? UUID()
        self.objectifGlobal = objectifGlobal
        self.dateDebut = dateDebut
        self.typeObjectif = typeObjectif
        self.poidsCible = poidsCible
        self.caloriesParJour = caloriesParJour
        self.proteines = proteines
        self.glucides = glucides
        self.lipides = lipides
        self.minsActivité = minsActivité
        self.caloriesBruleesParJour = caloriesBruleesParJour
        self.nbEntrainementsHebdo = nbEntrainementsHebdo
    }

}

