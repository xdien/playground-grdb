import Foundation
import GRDB

struct Book: TableRecord, Codable {
    static let author = belongsTo(Author.self)
    var id: Int64?
    var title: String
    
    public init(id: Int64? = nil, title: String) {
        self.id = id
        self.title = title
    }
    

    enum Columns: String, CodingKey {
        case id
        case title
    }
}
