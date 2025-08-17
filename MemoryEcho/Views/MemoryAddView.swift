import SwiftUI
import UniformTypeIdentifiers

struct MemoryAddView: View {
    let role: Role
    @EnvironmentObject var knowledgeManager: KnowledgeManager
    @EnvironmentObject var aiService: AIService
    @Environment(\.dismiss) private var dismiss
    
    @State private var memoryType: MemoryType = .text
    @State private var textContent = ""
    @State private var selectedFiles: [URL] = []
    @State private var isProcessing = false
    @State private var showingFilePicker = false
    @State private var showingDocumentPicker = false
    
    enum MemoryType: String, CaseIterable {
        case text = "文本记忆"
        case file = "文件记忆"
        
        var icon: String {
            switch self {
            case .text: return "text.quote"
            case .file: return "doc.text"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("记忆类型") {
                    Picker("选择类型", selection: $memoryType) {
                        ForEach(MemoryType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if memoryType == .text {
                    Section("文本内容") {
                        TextField("输入记忆内容...", text: $textContent, axis: .vertical)
                            .lineLimit(5...10)
                    }
                } else {
                    Section("文件上传") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("支持的文件类型：")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("• 文本文件 (.txt, .md, .docx)")
                            Text("• 音频文件 (.mp3, .wav, .m4a)")
                            Text("• 视频文件 (.mp4, .mov)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Button("选择文件") {
                                showingDocumentPicker = true
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 8)
                            
                            if !selectedFiles.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("已选择的文件：")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    ForEach(selectedFiles, id: \.self) { url in
                                        HStack {
                                            Image(systemName: "doc")
                                                .foregroundColor(.blue)
                                            Text(url.lastPathComponent)
                                                .font(.caption)
                                            Spacer()
                                            Button("删除") {
                                                selectedFiles.removeAll { $0 == url }
                                            }
                                            .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                }
                
                Section("AI处理") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI将自动分析您上传的内容，提取关键信息，并整合到角色的知识库中。")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Toggle("启用AI智能分析", isOn: .constant(true))
                    }
                }
            }
            .navigationTitle("添加记忆")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveMemory()
                    }
                    .disabled(isProcessing || (memoryType == .text && textContent.isEmpty) || (memoryType == .file && selectedFiles.isEmpty))
                }
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [.text, .audio, .movie],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                selectedFiles.append(contentsOf: urls)
            case .failure(let error):
                print("文件选择失败: \(error.localizedDescription)")
            }
        }
        .onChange(of: memoryType) { _ in
            // 切换类型时清空内容
            textContent = ""
            selectedFiles.removeAll()
        }
    }
    
    private func saveMemory() {
        isProcessing = true
        
        if memoryType == .text {
            // 保存文本记忆
            let knowledge = Knowledge(
                roleId: role.id,
                name: "文本记忆",
                content: textContent,
                type: .text
            )
            knowledgeManager.addKnowledge(knowledge)
            
            // AI处理
            Task {
                await processWithAI([textContent])
                await MainActor.run {
                    isProcessing = false
                    dismiss()
                }
            }
        } else {
            // 保存文件记忆
            let fileNames = selectedFiles.map { $0.lastPathComponent }
            let fileContents = selectedFiles.map { "文件: \($0.lastPathComponent)" }
            
            let knowledge = Knowledge(
                roleId: role.id,
                name: "文件记忆",
                content: fileContents.joined(separator: "\n"),
                type: .file
            )
            knowledgeManager.addKnowledge(knowledge)
            
            // AI处理
            Task {
                await processWithAI(fileContents)
                await MainActor.run {
                    isProcessing = false
                    dismiss()
                }
            }
        }
    }
    
    private func processWithAI(_ contents: [String]) async {
        // 调用AI服务处理记忆内容
        _ = await aiService.processKnowledge(roleId: role.id, knowledgeContent: contents)
    }
}

#Preview {
    MemoryAddView(role: Role(name: "Kevin", description: "技术人文"))
        .environmentObject(KnowledgeManager())
        .environmentObject(AIService())
}
