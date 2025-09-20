import Foundation
import SwiftUI

class RoleManager: ObservableObject {
    @Published var roles: [Role] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let userDefaults = UserDefaults.standard
    private let rolesKey = "user_roles"
    
    init() {
        loadRoles()
    }
    
    func loadRoles() {
        isLoading = true
        // 模拟从API加载数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let data = self.userDefaults.data(forKey: self.rolesKey),
               let decodedRoles = try? JSONDecoder().decode([Role].self, from: data) {
                self.roles = decodedRoles
            } else {
                // 添加默认角色
                let defaultRole = Role(
                    voiceId: "default_voice",
                    belongsTo: "current_user",
                    name: "Kevin",
                    description: "我是一个在技术与人文之间搭建桥梁的人。我痴迷于用代码，去捕捉那些最真实、最温暖的家庭记忆。",
                    avatar: "person.circle.fill",
                    background: "技术人文"
                )
                self.roles = [defaultRole]
                self.saveRoles()
            }
            self.isLoading = false
        }
    }
    
    func addRole(_ role: Role) {
        roles.append(role)
        saveRoles()
    }
    
    func updateRole(_ role: Role) {
        if let index = roles.firstIndex(where: { $0.id == role.id }) {
            roles[index] = role
            saveRoles()
        }
    }
    
    func deleteRole(_ role: Role) {
        roles.removeAll { $0.id == role.id }
        saveRoles()
    }
    
    func getRole(by id: String) -> Role? {
        return roles.first { $0.id == id }
    }
    
    private func saveRoles() {
        if let encoded = try? JSONEncoder().encode(roles) {
            userDefaults.set(encoded, forKey: rolesKey)
        }
    }
}
