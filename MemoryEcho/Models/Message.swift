import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let sender: MessageSender
    let senderId: String
    let type: MessageType
    let content: String
    let timestamp: Date
    
    enum MessageSender: String, Codable {
        case user = "user"
        case ai = "ai"
    }
    
    enum MessageType: String, Codable {
        case text = "text"
        case voice = "voice"
    }
    
    init(id: String = UUID().uuidString,
         sender: MessageSender,
         senderId: String,
         type: MessageType,
         content: String,
         timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.senderId = senderId
        self.type = type
        self.content = content
        self.timestamp = timestamp
    }
}
