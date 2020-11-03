//
//  File.swift
//  
//
//  Created by Brett Chapin on 11/2/20.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

struct CreateMovie: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies")
            .id()
            .field("title", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies")
            .delete()
    }
}
