import SwiftUI

struct MemoryCorridorView: View {
    @EnvironmentObject var roleManager: RoleManager
    @EnvironmentObject var threadManager: ThreadManager
    @State private var showingRoleEdit = false
    @State private var selectedRole: Role?
    
    var body: some View {
        NavigationView {
            VStack {
                // 头部
                HStack {
                    Text("记忆回廊")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showingRoleEdit = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // 内容区域
                if roleManager.isLoading {
                    LoadingView()
                } else if roleManager.roles.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(roleManager.roles) { role in
                                RoleCardView(role: role) {
                                    selectedRole = role
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingRoleEdit) {
            RoleEditView()
                .environmentObject(roleManager)
        }
        .sheet(item: $selectedRole) { role in
            ChatView(role: role)
                .environmentObject(threadManager)
                .environmentObject(roleManager)
        }
    }
}

struct RoleCardView: View {
    let role: Role
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 头像
                Image(systemName: role.avatar)
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 60)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                // 角色信息
                VStack(alignment: .leading, spacing: 8) {
                    Text(role.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(role.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(role.background)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // 箭头
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("加载中...")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("还没有创建任何角色")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("点击右上角的 + 号创建第一个角色")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    MemoryCorridorView()
        .environmentObject(RoleManager())
        .environmentObject(ThreadManager())
}
