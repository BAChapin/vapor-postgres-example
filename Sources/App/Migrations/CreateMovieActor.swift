//
//  File.swift
//  
//
//  Created by Brett Chapin on 11/3/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateMovieActor: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movie_actors")
            .id()
            .field("movie_id", .uuid, .required, .references("movies", "id"))
            .field("actor_id", .uuid, .required, .references("actors", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movie_actors").delete()
    }
}
