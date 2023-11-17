import Foundation
import GRDB

struct Author: TableRecord {
    static let books = hasMany(Book.self)

    var id: Int64?
    var name: String
}
