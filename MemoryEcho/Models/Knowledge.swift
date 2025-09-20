import Foundation

struct Knowledge: Identifiable, Codable {
    let id: String
    let roleId: String
    let name: String
    let content: String
    let type: KnowledgeType
    let createdAt: Date
    let updatedAt: Date
    
    enum KnowledgeType: String, Codable, CaseIterable {
        case text = "text"
        case file = "file"
    }
    
    init(id: String = UUID().uuidString,
         roleId: String,
         name: String = "",
         content: String,
         type: KnowledgeType = .text,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.roleId = roleId
        self.name = name.isEmpty ? "记忆 #\(Int(Date().timeIntervalSince1970))" : name
        self.content = content
        self.type = type
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
