//
//  ObjectifDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct ObjectifDTO: Content {
    var id: UUID?
    var objectifGlobal: UserObjectifGlobal
    var dateDebut: Date
    var dateFin: Date?
    var typeObjectif : TypeObjectif
    var poidsCible: Double?
    var caloriesParJour: Double?
    var proteines : Double?
    var glucides : Double?
    var lipides : Double?
    var minsActivité: Int?
    var caloriesBruleesParJour: Double?
    var nbEntrainementsHebdo: Int?
}

struct ObjectifUpdateDTO: Content {
    var objectifGlobal: UserObjectifGlobal?
    var dateDebut: Date?
    var typeObjectif : TypeObjectif?
    var poidsCible: Double?
    var caloriesParJour: Double?
    var proteines : Double?
    var glucides : Double?
    var lipides : Double?
    var minsActivité: Int?
    var caloriesBruleesParJour: Double?
    var nbEntrainementsHebdo: Int?
}
