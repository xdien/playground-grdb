import Foundation
import GRDB

// swiftlint:disable function_body_length
func migrations_v001(db: Database) throws {
    try db.create(table: Author.databaseTableName) { table in
        table.column(Author.Columns.id.rawValue, .integer).primaryKey()
        table.column(Author.Columns.name.rawValue, .text).notNull()
    }

    try db.create(table: Book.databaseTableName) { table in
        table.column(Book.Columns.id.rawValue, .integer).primaryKey()
        table.column(Book.Columns.title.rawValue, .text).notNull()
        table.column(Book.Columns.authorId.rawValue, .integer).notNull().references(Author.databaseTableName, onDelete: .cascade)
    }
    try db.create(table: AuthorInfo.databaseTableName) { table in
        table.column(AuthorInfo.Columns.author.rawValue, .text).notNull()
        table.column(AuthorInfo.Columns.books.rawValue, .text).notNull()
    }
}

// swiftlint:enable function_body_length
