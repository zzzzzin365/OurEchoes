import SwiftUI

struct ContentView: View {
    @StateObject private var roleManager = RoleManager()
    @StateObject private var knowledgeManager = KnowledgeManager()
    @StateObject private var threadManager = ThreadManager()
    @StateObject private var aiService = AIService()
    @StateObject private var voiceService = VoiceService()
    
    var body: some View {
        TabView {
            // 记忆回廊 - 主页面
            MemoryCorridorView()
                .environmentObject(roleManager)
                .environmentObject(knowledgeManager)
                .environmentObject(threadManager)
                .environmentObject(aiService)
                .environmentObject(voiceService)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("记忆回廊")
                }
            
            // 语音管理
            VoiceManagementView()
                .environmentObject(voiceService)
                .tabItem {
                    Image(systemName: "mic.circle")
                    Text("语音管理")
                }
            
            // 设置
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
