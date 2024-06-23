import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.middleware.use(RequestLoggerMiddleware())
    app.middleware.use(LoadBalancerMiddleware())
}
