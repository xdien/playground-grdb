import Foundation
import GRDB

struct Book: TableRecord, Codable {
    
    func encode(to container: inout GRDB.PersistenceContainer) throws {
        container[Columns.id.rawValue] = id
        container[Columns.title.rawValue] = title
        container[Columns.authorId.rawValue] = authorId
    }
    
    var id: Int64?
    var title: String
    var authorId: Int64
    public init(id: Int64? = nil, title: String, authorId: Int64) {
        self.id = id
        self.title = title
        self.authorId = authorId
    }
    static let author = belongsTo(Author.self)

    enum Columns: String, CodingKey {
        case id
        case title
        case authorId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        id = try container.decode(Int64.self)
        title = try container.decode(String.self)
        authorId = try container.decode(Int64.self)
    }
}

extension Book :DatabaseValueConvertible {
    public var databaseValue: DatabaseValue {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            let string = String(data: data, encoding: .utf8)!
            return string.databaseValue
        } catch {
            print("Can't convert object to string json ")
            return "".databaseValue
        }
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Self? {
        guard
            let string = String.fromDatabaseValue(dbValue),
            let data = string.data(using: .utf8)
        else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(self, from: data)
    }
}
