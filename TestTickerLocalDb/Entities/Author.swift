import Foundation
import GRDB

class Author: TableRecord, Codable {
    static let books = hasMany(Book.self)

    var id: Int64?
    var name: String
    
    init(id: Int64? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    enum Columns: String, CodingKey {
        case id
        case name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        id = try container.decode(Int64.self)
        name = try container.decode(String.self)
    }
}

extension Author : DatabaseValueConvertible{
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
