import Foundation

struct Role: Identifiable, Codable {
    let id: String
    let voiceId: String
    let belongsTo: String
    let name: String
    let description: String
    let avatar: String
    let background: String
    
    init(id: String = UUID().uuidString,
         voiceId: String = "",
         belongsTo: String = "",
         name: String = "",
         description: String = "",
         avatar: String = "",
         background: String = "") {
        self.id = id
        self.voiceId = voiceId
        self.belongsTo = belongsTo
        self.name = name
        self.description = description
        self.avatar = avatar
        self.background = background
    }
}
