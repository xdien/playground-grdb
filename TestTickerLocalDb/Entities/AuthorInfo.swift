import Foundation
import GRDB

struct AuthorInfo: Decodable, FetchableRecord  {
    var author: Author
    var books: [Book]
}
