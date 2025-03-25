import SwiftUI
import Combine

/// 支持缓存的图片加载组件
struct CachedImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var loadedImage: UIImage? = nil
    @State private var isLoading: Bool = false
    
    init(url: URL?,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                content(Image(uiImage: loadedImage))
            } else {
                placeholder()
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url, !isLoading else { return }
        
        isLoading = true
        
        Task {
            // 尝试从缓存加载
            if let cachedImage = await ImageCacheManager.shared.loadImageFromCache(url: url) {
                await MainActor.run {
                    self.loadedImage = cachedImage
                    self.isLoading = false
                }
                return
            }
            
            // 从网络加载
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    // 保存到缓存
                    await ImageCacheManager.shared.saveImageToCache(image, url: url)
                    
                    await MainActor.run {
                        self.loadedImage = image
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

// 便捷初始化方法
extension CachedImage where Content == Image, Placeholder == ProgressView<EmptyView, EmptyView> {
    init(url: URL?, scale: CGFloat = 1.0, transaction: Transaction = Transaction()) {
        self.init(url: url, scale: scale, transaction: transaction) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
    }
}

// 便捷初始化方法 - 字符串URL
extension CachedImage {
    init(urlString: String,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.init(url: URL(string: urlString), scale: scale, transaction: transaction, content: content, placeholder: placeholder)
    }
}