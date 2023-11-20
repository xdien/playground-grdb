import Foundation
import GRDB

class Author: TableRecord, Codable {
    

    var id: Int64?
    var name: String
    static let books = hasMany(Book.self)
    
    init(id: Int64? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    enum Columns: String, CodingKey {
        case id
        case name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Columns.self)
        id = try container.decodeIfPresent(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    required init(row: Row) throws {
        id = row[Columns.id.rawValue]
        name = row[Columns.name.rawValue]
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
