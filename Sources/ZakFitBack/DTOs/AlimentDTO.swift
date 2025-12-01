//
//  AlimentDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct AlimentDTO: Content {
    var id : UUID?
    var nom : String
    var portion : Portion
    var calories : Double
    var proteines : Double
    var glucides : Double
    var lipides : Double
}
