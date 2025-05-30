import SwiftUI

struct MomentsView: View {
    @StateObject private var viewModel = MomentsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        // 顶部背景和头像
                        headerView
                        
                        // 朋友圈列表
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.moments) { moment in
                                MomentCell(moment: moment)
                                Divider()
                            }
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchData()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle("朋友圈", displayMode: .inline)
            .navigationBarItems(trailing: cameraButton)
        }
        .task {
            await viewModel.fetchData()
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error))
        }
    }
    
    private var headerView: some View {
        ZStack(alignment: .bottomTrailing) {
            // 背景图
            CachedImage(urlString: viewModel.userProfile?.profileImage ?? "") { image in
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(height: 300)
            .clipped()
            
            // 用户头像和昵称
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(viewModel.userProfile?.nick ?? "")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    CachedImage(urlString: viewModel.userProfile?.avatar ?? "") { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.white)
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
    }
    
    private var cameraButton: some View {
        Button(action: {
            // 相机功能
        }) {
            Image(systemName: "camera")
                .foregroundColor(.black)
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String {
        self
    }
}
