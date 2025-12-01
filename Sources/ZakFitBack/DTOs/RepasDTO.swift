//
//  RepasDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct RepasDTO: Content {
    var id : UUID?
    var typeRepas : TypeRepas
    var date : Date
    var calories : Double
    var consos : [ConsoDTO]
}
