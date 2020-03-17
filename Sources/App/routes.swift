import Corvus
import Vapor

public func routes(_ app: Application) throws {
    let api = Api()
    try app.register(collection: api)
}
