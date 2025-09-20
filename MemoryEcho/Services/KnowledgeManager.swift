import Foundation
import SwiftUI

class KnowledgeManager: ObservableObject {
    @Published var knowledgeList: [Knowledge] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let userDefaults = UserDefaults.standard
    private let knowledgeKey = "knowledge_data"
    private let roleKnowledgeKey = "role_knowledge"
    
    func addKnowledge(_ knowledge: Knowledge) {
        knowledgeList.append(knowledge)
        saveKnowledge()
    }
    
    func getRoleKnowledge(roleId: String) -> [Knowledge] {
        return knowledgeList.filter { $0.roleId == roleId }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func updateKnowledge(_ knowledge: Knowledge) {
        if let index = knowledgeList.firstIndex(where: { $0.id == knowledge.id }) {
            knowledgeList[index] = knowledge
            saveKnowledge()
        }
    }
    
    func deleteKnowledge(_ knowledge: Knowledge) {
        knowledgeList.removeAll { $0.id == knowledge.id }
        saveKnowledge()
    }
    
    func addBatchKnowledge(roleId: String, contents: [String], names: [String]? = nil) -> [Knowledge] {
        var newKnowledge: [Knowledge] = []
        
        for (index, content) in contents.enumerated() {
            if !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let name = names?[index] ?? ""
                let knowledge = Knowledge(
                    roleId: roleId,
                    name: name,
                    content: content.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                newKnowledge.append(knowledge)
            }
        }
        
        knowledgeList.append(contentsOf: newKnowledge)
        saveKnowledge()
        return newKnowledge
    }
    
    func getRoleKnowledgeText(roleId: String) -> [String] {
        return getRoleKnowledge(roleId: roleId).map { $0.content }
    }
    
    private func saveKnowledge() {
        if let encoded = try? JSONEncoder().encode(knowledgeList) {
            userDefaults.set(encoded, forKey: knowledgeKey)
        }
    }
    
    private func loadKnowledge() {
        if let data = userDefaults.data(forKey: knowledgeKey),
           let decoded = try? JSONDecoder().decode([Knowledge].self, from: data) {
            knowledgeList = decoded
        }
    }
}
