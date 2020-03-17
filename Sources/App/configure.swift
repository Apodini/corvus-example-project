import Corvus
import Vapor
import FluentSQLiteDriver

public func configure(_ app: Application) throws {

    app.middleware.use(CorvusUser.authenticator().middleware())
    app.middleware.use(CorvusToken.authenticator().middleware())
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreateAccount())
    app.migrations.add(CreateTransaction())
    app.migrations.add(CreateCorvusUser())
    app.migrations.add(CreateCorvusToken())
    try app.autoMigrate().wait()

    try routes(app)
}
