import Foundation
import AVFoundation
import SwiftUI

class VoiceService: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var isRecording = false
    @Published var error: String?
    
    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default)
            try audioSession?.setActive(true)
        } catch {
            self.error = "音频会话设置失败: \(error.localizedDescription)"
        }
    }
    
    // 播放语音
    func playVoice(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            self.error = "播放失败: \(error.localizedDescription)"
        }
    }
    
    // 停止播放
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    // 开始录音
    func startRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
        } catch {
            self.error = "录音失败: \(error.localizedDescription)"
        }
    }
    
    // 停止录音
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    // 合成语音（模拟Index TTS）
    func synthesizeSpeech(text: String, voiceId: String) async -> URL? {
        // 这里应该调用真实的Index TTS API
        // 现在返回模拟的音频文件URL
        
        // 模拟处理延迟
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5秒
        
        // 返回一个模拟的音频文件URL
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent("synthesized_speech.m4a")
    }
    
    // 语音克隆（模拟）
    func cloneVoice(audioFile: URL, text: String) async -> URL? {
        // 这里应该调用真实的语音克隆API
        // 现在返回模拟的音频文件URL
        
        // 模拟处理延迟
        try? await Task.sleep(nanoseconds: 2_500_000_000) // 2.5秒
        
        // 返回一个模拟的克隆语音文件URL
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent("cloned_voice.m4a")
    }
}

// MARK: - AVAudioPlayerDelegate
extension VoiceService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension VoiceService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
}
