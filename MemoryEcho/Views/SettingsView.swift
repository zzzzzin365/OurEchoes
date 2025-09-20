import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("autoSave") private var autoSave = true
    @AppStorage("voiceEnabled") private var voiceEnabled = true
    @AppStorage("aiEnabled") private var aiEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section("用户信息") {
                    TextField("用户名", text: $username)
                    Text("当前用户：\(username.isEmpty ? "未设置" : username)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("应用设置") {
                    Toggle("自动保存", isOn: $autoSave)
                    Toggle("启用语音功能", isOn: $voiceEnabled)
                    Toggle("启用AI功能", isOn: $aiEnabled)
                }
                
                Section("数据管理") {
                    Button("导出数据") {
                        // 导出功能
                    }
                    
                    Button("清除所有数据") {
                        // 清除功能
                    }
                    .foregroundColor(.red)
                }
                
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
}
