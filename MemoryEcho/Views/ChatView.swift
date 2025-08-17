import SwiftUI

struct ChatView: View {
    let role: Role
    @EnvironmentObject var threadManager: ThreadManager
    @EnvironmentObject var roleManager: RoleManager
    @EnvironmentObject var aiService: AIService
    @EnvironmentObject var voiceService: VoiceService
    @Environment(\.dismiss) private var dismiss
    
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var isSending = false
    @State private var currentThread: Thread?
    @State private var showingMemoryAdd = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 头部信息
                HStack {
                    Button("返回") {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: role.avatar)
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text(role.name)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Button("记忆") {
                        showingMemoryAdd = true
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                // 消息列表
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                MessageBubbleView(message: message, role: role)
                            }
                            
                            if isSending {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastMessage = messages.last {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 输入区域
                HStack {
                    TextField("输入消息...", text: $newMessage, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...4)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                    }
                    .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            setupChat()
        }
        .sheet(isPresented: $showingMemoryAdd) {
            MemoryAddView(role: role)
        }
    }
    
    private func setupChat() {
        // 创建或获取对话线程
        if currentThread == nil {
            currentThread = threadManager.createThread(roleId: role.id)
        }
        
        // 加载现有消息
        if let thread = currentThread {
            messages = thread.content
        }
    }
    
    private func sendMessage() {
        let messageText = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !messageText.isEmpty else { return }
        
        // 添加用户消息
        let userMessage = Message(
            sender: .user,
            senderId: "current_user",
            type: .text,
            content: messageText
        )
        
        messages.append(userMessage)
        newMessage = ""
        isSending = true
        
        // 添加到线程
        if let thread = currentThread {
            threadManager.addMessage(to: thread.id, message: userMessage)
        }
        
        // 生成AI响应
        Task {
            let context = getContext()
            if let response = await aiService.generateResponse(for: messageText, context: context) {
                await MainActor.run {
                    let aiMessage = Message(
                        sender: .ai,
                        senderId: role.id,
                        type: .text,
                        content: response
                    )
                    
                    messages.append(aiMessage)
                    isSending = false
                    
                    // 添加到线程
                    if let thread = currentThread {
                        threadManager.addMessage(to: thread.id, message: aiMessage)
                    }
                    
                    // 播放语音（如果启用）
                    playVoiceForMessage(aiMessage)
                }
            } else {
                await MainActor.run {
                    isSending = false
                }
            }
        }
    }
    
    private func getContext() -> [String] {
        // 这里应该从KnowledgeManager获取角色的知识内容
        // 现在返回模拟数据
        return [
            "我是一个在技术与人文之间搭建桥梁的人。",
            "我痴迷于用代码，去捕捉那些最真实、最温暖的家庭记忆。",
            "我相信科技最大的价值，不是创造一个冰冷的未来，而是让我们能更好地传承一个温暖的过去。"
        ]
    }
    
    private func playVoiceForMessage(_ message: Message) {
        // 这里应该调用语音服务播放AI回复
        // 现在只是模拟
        print("播放语音: \(message.content)")
    }
}

struct MessageBubbleView: View {
    let message: Message
    let role: Role
    
    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: role.avatar)
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Text(role.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ChatView(role: Role(name: "Kevin", description: "技术人文"))
        .environmentObject(ThreadManager())
        .environmentObject(RoleManager())
        .environmentObject(AIService())
        .environmentObject(VoiceService())
}
