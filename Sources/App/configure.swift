import Corvus
import Vapor
import FluentSQLiteDriver

func configure(_ app: Application) throws {

    app.middleware.use(CorvusUser.authenticator().middleware())
    app.middleware.use(CorvusToken.authenticator().middleware())
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(Account.Migration())
    app.migrations.add(Transaction.Migration())
    app.migrations.add(CorvusUser.Migration())
    app.migrations.add(CorvusToken.Migration())
    try app.autoMigrate().wait()

    try routes(app)
}
