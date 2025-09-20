import Foundation
import SwiftUI

class AIService: ObservableObject {
    @Published var isProcessing = false
    @Published var error: String?

    func generateResponse(for message: String, context: [String]) async -> String? {
        isProcessing = true
        error = nil

        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let responses = [
            "我理解你的问题。基于我的记忆，我可以这样回答...",
            "这是一个很有趣的问题。让我想想...",
            "根据我了解的信息，我认为...",
            "谢谢你的提问。让我为你详细解释一下...",
            "这让我想起了我们之前讨论过的话题..."
        ]

        let randomResponse = responses.randomElement() ?? "我理解你的问题。"

        DispatchQueue.main.async {
            self.isProcessing = false
        }

        return randomResponse
    }

    func processKnowledge(roleId: String, knowledgeContent: [String]) async -> String? {
        isProcessing = true
        error = nil

        try? await Task.sleep(nanoseconds: 3_000_000_000)

        let processedContent = """
        基于您提供的记忆内容，我已经整理出了以下关键信息：

        1. 个人背景和经历
        2. 专业技能和知识
        3. 价值观和人生哲学
        4. 重要的人际关系

        现在我可以作为您的智慧分身，回答各种问题，分享您的见解和经验。
        """

        DispatchQueue.main.async {
            self.isProcessing = false
        }

        return processedContent
    }
}
