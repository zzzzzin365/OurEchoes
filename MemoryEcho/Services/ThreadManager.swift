import Foundation
import SwiftUI

class ThreadManager: ObservableObject {
    @Published var threads: [Thread] = []
    @Published var currentThread: Thread?
    @Published var isLoading = false
    @Published var error: String?
    
    private let userDefaults = UserDefaults.standard
    private let threadsKey = "threads_data"
    
    func createThread(roleId: String, userId: String = "current_user") -> Thread {
        let thread = Thread(
            userId: userId,
            roleId: roleId,
            title: "新对话"
        )
        threads.append(thread)
        saveThreads()
        return thread
    }
    
    func getThread(by id: String) -> Thread? {
        return threads.first { $0.id == id }
    }
    
    func getUserThreads(userId: String) -> [Thread] {
        return threads.filter { $0.roleId == userId }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
    
    func addMessage(to threadId: String, message: Message) {
        if let index = threads.firstIndex(where: { $0.id == threadId }) {
            threads[index].content.append(message)
            threads[index].updatedAt = Date()
            saveThreads()
        }
    }
    
    func updateThread(_ thread: Thread) {
        if let index = threads.firstIndex(where: { $0.id == thread.id }) {
            threads[index] = thread
            saveThreads()
        }
    }
    
    func deleteThread(_ thread: Thread) {
        threads.removeAll { $0.id == thread.id }
        saveThreads()
    }
    
    private func saveThreads() {
        if let encoded = try? JSONEncoder().encode(threads) {
            userDefaults.set(encoded, forKey: threadsKey)
        }
    }
    
    private func loadThreads() {
        if let data = userDefaults.data(forKey: threadsKey),
           let decoded = try? JSONDecoder().decode([Thread].self, from: data) {
            threads = decoded
        }
    }
}
