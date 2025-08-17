import SwiftUI
import AVFoundation

struct VoiceManagementView: View {
    @EnvironmentObject var voiceService: VoiceService
    @State private var showingVoiceUpload = false
    @State private var showingVoiceSettings = false
    
    var body: some View {
        NavigationView {
            List {
                Section("语音功能") {
                    NavigationLink(destination: VoiceUploadView()) {
                        HStack {
                            Image(systemName: "mic.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text("语音上传")
                                    .font(.headline)
                                Text("上传音频文件用于语音克隆")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: VoiceSettingsView()) {
                        HStack {
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text("语音设置")
                                    .font(.headline)
                                Text("配置TTS和语音克隆参数")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("语音状态") {
                    HStack {
                        Image(systemName: "mic.fill")
                            .foregroundColor(voiceService.isRecording ? .red : .gray)
                        Text("录音状态")
                        Spacer()
                        Text(voiceService.isRecording ? "录音中..." : "未录音")
                            .foregroundColor(voiceService.isRecording ? .red : .secondary)
                    }
                    
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(voiceService.isPlaying ? .blue : .gray)
                        Text("播放状态")
                        Spacer()
                        Text(voiceService.isPlaying ? "播放中..." : "未播放")
                            .foregroundColor(voiceService.isPlaying ? .blue : .secondary)
                    }
                }
                
                Section("快速操作") {
                    Button(action: {
                        if voiceService.isRecording {
                            voiceService.stopRecording()
                        } else {
                            voiceService.startRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: voiceService.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .foregroundColor(voiceService.isRecording ? .red : .blue)
                            Text(voiceService.isRecording ? "停止录音" : "开始录音")
                        }
                    }
                    .disabled(voiceService.isPlaying)
                    
                    Button(action: {
                        if voiceService.isPlaying {
                            voiceService.stopPlaying()
                        }
                    }) {
                        HStack {
                            Image(systemName: "stop.circle.fill")
                                .foregroundColor(.red)
                            Text("停止播放")
                        }
                    }
                    .disabled(!voiceService.isPlaying)
                }
                
                if let error = voiceService.error {
                    Section("错误信息") {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("语音管理")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct VoiceUploadView: View {
    @EnvironmentObject var voiceService: VoiceService
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedAudioFile: URL?
    @State private var voiceName = ""
    @State private var voiceDescription = ""
    @State private var isProcessing = false
    @State private var showingDocumentPicker = false
    
    var body: some View {
        Form {
            Section("音频文件") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("选择音频文件用于语音克隆：")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("• 支持格式：MP3, WAV, M4A")
                    Text("• 建议时长：10-60秒")
                    Text("• 音质要求：清晰无噪音")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("选择音频文件") {
                        showingDocumentPicker = true
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)
                    
                    if let file = selectedAudioFile {
                        HStack {
                            Image(systemName: "waveform")
                                .foregroundColor(.blue)
                            Text(file.lastPathComponent)
                            Spacer()
                            Button("删除") {
                                selectedAudioFile = nil
                            }
                            .foregroundColor(.red)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            
            Section("语音信息") {
                TextField("语音名称", text: $voiceName)
                TextField("语音描述", text: $voiceDescription, axis: .vertical)
                    .lineLimit(2...4)
            }
            
            Section("处理选项") {
                Toggle("启用语音克隆", isOn: .constant(true))
                Toggle("启用TTS合成", isOn: .constant(true))
            }
            
            if isProcessing {
                Section {
                    HStack {
                        ProgressView()
                        Text("处理中...")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("语音上传")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    saveVoice()
                }
                .disabled(selectedAudioFile == nil || voiceName.isEmpty || isProcessing)
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                selectedAudioFile = urls.first
            case .failure(let error):
                print("文件选择失败: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveVoice() {
        guard let audioFile = selectedAudioFile else { return }
        
        isProcessing = true
        
        // 模拟语音克隆处理
        Task {
            if let clonedVoice = await voiceService.cloneVoice(audioFile: audioFile, text: "测试语音克隆") {
                await MainActor.run {
                    isProcessing = false
                    dismiss()
                }
            } else {
                await MainActor.run {
                    isProcessing = false
                }
            }
        }
    }
}

struct VoiceSettingsView: View {
    @State private var ttsEnabled = true
    @State private var voiceCloneEnabled = true
    @State private var autoPlay = false
    @State private var voiceSpeed: Double = 1.0
    @State private var voicePitch: Double = 1.0
    
    var body: some View {
        Form {
            Section("TTS设置") {
                Toggle("启用TTS", isOn: $ttsEnabled)
                Toggle("自动播放", isOn: $autoPlay)
                
                VStack(alignment: .leading) {
                    Text("语音速度: \(String(format: "%.1f", voiceSpeed))x")
                    Slider(value: $voiceSpeed, in: 0.5...2.0, step: 0.1)
                }
                
                VStack(alignment: .leading) {
                    Text("语音音调: \(String(format: "%.1f", voicePitch))x")
                    Slider(value: $voicePitch, in: 0.5...2.0, step: 0.1)
                }
            }
            
            Section("语音克隆设置") {
                Toggle("启用语音克隆", isOn: $voiceCloneEnabled)
                Text("语音克隆需要上传音频样本")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("高级设置") {
                NavigationLink("音频质量设置") {
                    Text("音频质量设置页面")
                }
                
                NavigationLink("语音模型选择") {
                    Text("语音模型选择页面")
                }
            }
        }
        .navigationTitle("语音设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VoiceManagementView()
        .environmentObject(VoiceService())
}
