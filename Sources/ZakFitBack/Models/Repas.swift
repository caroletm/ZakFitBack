//
//  Repas.swift
//  ZakFitBack
//
//  Created by caroletm on 30/11/2025.
//

import Vapor
import Fluent

final class Repas : Model, Content, @unchecked Sendable {
    static let schema = "Repas"
    
    @ID(key: .id) var id : UUID?
    @Enum(key: "typeRepas") var typeRepas: TypeRepas
    @Field(key: "date") var date: Date
    @Field(key: "calories") var calories: Double
    @Parent(key: "user_Id") var user: User
    @Children(for : \.$repas) var consos: [Conso]
    
    init() {}
    
    init(id: UUID? = nil, typeRepas: TypeRepas, date: Date, calories: Double, user_Id : User.IDValue) {
        self.id = id ?? UUID()
        self.typeRepas = typeRepas
        self.date = date
        self.calories = calories
        self.$user.id = user_Id
    }
   

}
