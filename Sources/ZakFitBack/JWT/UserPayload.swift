//
//  UserPayload.swift
//  ZakFitBack
//
//  Created by caroletm on 01/12/2025.
//

import Foundation
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id : UUID
    var expiration: Date
    
    func verify(using signer: JWTSigner) throws {
//        if self.expiration < Date() {
//            throw JWTError.invalidJWK
//        }
    }
    init(id:UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(3600 * 24)
    }
}
