import Foundation
import GRDB

// swiftlint:disable function_body_length
func migrations_v001(db: Database) throws {
    try db.create(table: Author.databaseTableName) { table in
        
    }

}

// swiftlint:enable function_body_length
