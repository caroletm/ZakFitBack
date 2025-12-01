//
//  Activite.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Vapor
import Fluent

final class Activite : Model, Content, @unchecked Sendable {
    static let schema = "Activite"
    
    @ID(key: .id) var id : UUID?
    @Enum(key: "typeActivite") var typeActivite: TypeActivite
    @Field(key: "date") var date: Date
    @Field(key: "duree") var duree: Int
    @Field(key: "caloriesBrulees") var caloriesBrulees: Double
    @Parent(key: "user_Id") var user: User
    
    init() {}
    
    init(id: UUID? = nil, typeActivite: TypeActivite, date: Date, duree: Int, caloriesBrulees: Double, user_Id : User.IDValue ) {
        self.id = id ?? UUID()
        self.typeActivite = typeActivite
        self.date = date
        self.duree = duree
        self.caloriesBrulees = caloriesBrulees
        self.$user.id = user_Id
    }
}

