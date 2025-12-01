//
//  ActiviteDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct ActiviteDTO: Content {
    var id: UUID?
    var typeActivite: TypeActivite
    var date: Date
    var duree: Int
    var caloriesBrulees: Double
}

struct ActiviteUpdateDTO: Content {
    var typeActivite: TypeActivite?
    var date: Date?
    var duree: Int?
    var caloriesBrulees: Double?
}
