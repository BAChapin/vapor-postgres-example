import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // Create DB entry Movie
    app.post("movies") { req -> EventLoopFuture<Movie> in
        
        let movie = try req.content.decode(Movie.self) // content = body of http request
        
        return movie.create(on: req.db).map { movie }
        
    }
    
    // Get all DB entries
    app.get("movies") { req in
        Movie.query(on: req.db).with(\.$actors).with(\.$reviews).all()
    }
    
    // Get specific movie based on ID
    app.get("movies", ":id") { req -> EventLoopFuture<Movie> in
        
        Movie.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    app.get("actors") { req in
        Actor.query(on: req.db).with(\.$movies).all()
    }
    
    // Updates a given movie with a body
    app.put("movies") { req -> EventLoopFuture<HTTPStatus> in
        let movie = try req.content.decode(Movie.self)
        
        return Movie.find(movie.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = movie.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    // Deletes a specific movie
    app.delete("movies", ":id") { req -> EventLoopFuture<HTTPStatus> in
        
        return Movie.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }.transform(to: .ok)
    }
    
    // Create a DB entry Review
    app.post("reviews") { req -> EventLoopFuture<Review> in
        let review = try req.content.decode(Review.self)
        
        return review.create(on: req.db).map { review }
    }
    
    // Create a DB entry Actor
    app.post("actors") { req -> EventLoopFuture<Actor> in
        let actor = try req.content.decode(Actor.self)
        
        return actor.create(on: req.db).map { actor }
    }
    
    // Create a DB entry
    app.post("movie", ":movieID", "actor", ":actorID") { req -> EventLoopFuture<HTTPStatus> in
        let movie = Movie.find(req.parameters.get("movieID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        let actor = Actor.find(req.parameters.get("actorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return movie.and(actor).flatMap { (movie, actor) in
            movie.$actors.attach(actor, on: req.db)
        }.transform(to: .ok)
    }
}
