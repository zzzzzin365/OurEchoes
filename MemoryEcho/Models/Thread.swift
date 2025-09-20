import Foundation

struct Thread: Identifiable, Codable {
    let id: String
    let userId: String
    let roleId: String
    let title: String
    let content: [Message]
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         roleId: String,
         title: String = "",
         content: [Message] = [],
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.roleId = roleId
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
