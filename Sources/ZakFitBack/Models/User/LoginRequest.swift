//
//  LoginRequest.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Vapor

struct LoginRequest: Content {
    let email: String
    let motDePasse: String
}


