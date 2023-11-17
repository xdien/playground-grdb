import Foundation
import GRDB

struct Book: TableRecord {
    var id: Int64?
    var title: String
    var authorId: Int64

    static let author = belongsTo(Author.self)
}
