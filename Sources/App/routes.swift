import Corvus
import Vapor

func routes(_ app: Application) throws {
    let api = Api()
    try app.register(collection: api)
}
