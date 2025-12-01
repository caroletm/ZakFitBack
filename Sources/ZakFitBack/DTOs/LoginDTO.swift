//
//  LoginDTO.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor
struct loginDTO: Content{
    let email: String
    let motDePasse: String
}
