import Foundation
import GRDB

struct ChatInfo: Decodable, FetchableRecord {
    
    var chat: Chat
    var messages: [Message?]
}

struct Chat: Codable, FetchableRecord, PersistableRecord {
    static let messages = hasMany(Message.self)
    var id: Int64
    var name: String
}

struct Message: Codable, FetchableRecord, PersistableRecord {
    static let chat = belongsTo(Chat.self)
    var id: Int64
    var chatID: Int64
    var date: Date
    var text: String
}
