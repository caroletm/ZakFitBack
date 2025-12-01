import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import Gatekeeper
import JWT
import FluentSQLiteDriver
import FluentSQL


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3306,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "ZakFit"
    ), as: .mysql)

//    app.migrations.add(CreateTodo())
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateObjectif())
    app.migrations.add(CreateActivite())
    app.migrations.add(CreateRepas())
    app.migrations.add(CreateAliment())
    app.migrations.add(CreateConso())
    app.migrations.add(UpdateObjectif())
    app.migrations.add(UpdateRepas())
    app.migrations.add(UpdateActivite())
    app.migrations.add(UpdateConsoFKeyRepas())
    app.migrations.add(UpdateConsoFKeyAliment())
    
    try await app.autoMigrate()
    
    // Utiliser un encodage de date en timestamp
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .secondsSince1970
    ContentConfiguration.global.use(encoder: jsonEncoder, for: .json)
    
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .secondsSince1970
    ContentConfiguration.global.use(decoder: jsonDecoder, for: .json)
    
        //Test rapide de connexion
        if let sql = app.db(.mysql) as? (any SQLDatabase) {
            sql.raw("SELECT 1").run().whenComplete { response in
                print(response)
            }
        } else {
            print("⚠️ Le driver SQL n'est pas disponible (cast vers SQLDatabase impossible)")
        }
    


    // register routes
    try routes(app)
}
