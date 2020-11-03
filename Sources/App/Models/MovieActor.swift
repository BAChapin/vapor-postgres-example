//
//  File.swift
//  
//
//  Created by Brett Chapin on 11/3/20.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class MovieActor: Model {
    static let schema = "movie_actors"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "movie_id")
    var movie: Movie
    
    @Parent(key: "actor_id")
    var actor: Actor
    
    init() { }
    
    init(movieID: UUID, actorID: UUID) {
        self.$movie.id = movieID
        self.$actor.id = actorID
    }
}
