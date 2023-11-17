import Foundation
import GRDB

struct AuthorInfo: FetchableRecord, Decodable, MutablePersistableRecord {
    func encode(to container: inout GRDB.PersistenceContainer) throws {
        container[Columns.author.rawValue] = author
        container[Columns.books.rawValue] = books
    }
    
    var author: Author
    var books: [Book]
    init(author: Author, books: [Book]) {
        self.author = author
        self.books = books
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        author = try container.decode(Author.self)
        books = try container.decode([Book].self)
    }

    enum Columns: String, CodingKey {
        case author
        case books
    }
}
