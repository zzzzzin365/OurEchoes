import SwiftUI

struct RoleEditView: View {
    @EnvironmentObject var roleManager: RoleManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var background = ""
    @State private var avatar = "person.circle.fill"
    @State private var voiceId = ""
    
    let avatars = [
        "person.circle.fill",
        "person.crop.circle.fill",
        "person.badge.plus",
        "person.2.circle.fill",
        "person.3.sequence.fill",
        "brain.head.profile",
        "heart.circle.fill",
        "star.circle.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本信息") {
                    TextField("角色名称", text: $name)
                    TextField("角色描述", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("背景标签", text: $background)
                }
                
                Section("头像选择") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(avatars, id: \.self) { avatarName in
                            Button(action: {
                                avatar = avatarName
                            }) {
                                Image(systemName: avatarName)
                                    .font(.title)
                                    .foregroundColor(avatar == avatarName ? .white : .blue)
                                    .frame(width: 50, height: 50)
                                    .background(avatar == avatarName ? Color.blue : Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("语音设置") {
                    TextField("语音ID", text: $voiceId)
                    Text("语音ID用于语音克隆和TTS合成")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("预览") {
                    HStack {
                        Image(systemName: avatar)
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(name.isEmpty ? "角色名称" : name)
                                .font(.headline)
                            Text(description.isEmpty ? "角色描述" : description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("创建角色")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveRole()
                    }
                    .disabled(name.isEmpty || description.isEmpty)
                }
            }
        }
    }
    
    private func saveRole() {
        let newRole = Role(
            voiceId: voiceId.isEmpty ? "default_voice" : voiceId,
            belongsTo: "current_user",
            name: name,
            description: description,
            avatar: avatar,
            background: background.isEmpty ? "未分类" : background
        )
        
        roleManager.addRole(newRole)
        dismiss()
    }
}

#Preview {
    RoleEditView()
        .environmentObject(RoleManager())
}
