import Corvus

final class Api: RestApi {

    let accountParameter = Parameter<Account>()

    var content: Endpoint {
        Group {
            BearerAuthGroup("api") {
                Group("accounts") {
                    Create<Account>()
                    ReadAll<Account>().auth(\.$user)
                    
                    Group(accountParameter.id) {
                        ReadOne<Account>(accountParameter.id)
                            .auth(\.$user)
                        Update<Account>(accountParameter.id)
                            .auth(\.$user)
                        Delete<Account>(accountParameter.id)
                            .auth(\.$user)

                        Group("transactions") {
                            ReadOne<Account>(accountParameter.id)
                                .children(\.$transactions).auth(\.$user)
                        }
                    }
                }

                CRUD<Transaction>("transactions")
            }

            Login("login")

            CRUD<CorvusUser>("users")
        }
    }
}
