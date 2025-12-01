//
//  ConsoDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct ConsoDTO: Content {
    var id : UUID?
    var aliment : String
    var portion: Portion
    var quantite : Int
    var calories : Double
    var glucides : Double
    var proteines : Double
    var lipides : Double
}

