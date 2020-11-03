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

struct CreateActor: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("actors")
            .id()
            .field("name", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("actors").delete()
    }
}
