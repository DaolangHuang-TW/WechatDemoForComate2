import SwiftUI

struct ImagePreviewView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex: Int
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isShowingControls = true
    @GestureState private var isDragging = false
    
    let images: [ImageItem]
    let initialIndex: Int
    
    init(images: [ImageItem], initialIndex: Int = 0) {
        self.images = images
        self.initialIndex = initialIndex
        _currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        ZStack {
            // 背景
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 图片展示区域
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    ZoomableImageView(
                        url: images[index].hdUrl ?? images[index].url,
                        onSingleTap: {
                            withAnimation {
                                isShowingControls.toggle()
                            }
                        },
                        onDismiss: {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // 控制栏
            if isShowingControls {
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(10)
                        }
                        
                        Spacer()
                        
                        Text("\(currentIndex + 1)/\(images.count)")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            // 保存图片功能 - 未实现
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        .statusBar(hidden: true)
        .onAppear {
            // 预加载相邻图片
            preloadAdjacentImages()
        }
        .onChange(of: currentIndex) { _ in
            // 当索引变化时预加载相邻图片
            preloadAdjacentImages()
        }
    }
    
    private func preloadAdjacentImages() {
        // 预加载前后的图片
        let indices = [
            max(0, currentIndex - 1),
            min(images.count - 1, currentIndex + 1)
        ]
        
        Task {
            for index in indices where index != currentIndex {
                let urlString = images[index].hdUrl ?? images[index].url
                guard let url = URL(string: urlString) else { continue }
                
                // 检查是否已经在缓存中
                if await ImageCacheManager.shared.loadImageFromCache(url: url) != nil {
                    continue
                }
                
                // 如果不在缓存中，则下载并缓存
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        await ImageCacheManager.shared.saveImageToCache(image, url: url)
                    }
                } catch {
                    print("Failed to preload image: \(error)")
                }
            }
        }
    }
}

// 可缩放的图片视图
struct ZoomableImageView: View {
    let url: String
    let onSingleTap: () -> Void
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                CachedImage(urlString: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .offset(offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newOffset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                        
                                        // 如果缩放级别为1，检测是否为向下拖动手势
                                        if scale <= 1.0 && abs(value.translation.width) < abs(value.translation.height) && value.translation.height > 50 {
                                            // 向下拖动，根据拖动距离调整透明度
                                            let dragPercentage = min(1.0, value.translation.height / 300)
                                            UIApplication.shared.windows.first?.rootViewController?.view.alpha = 1.0 - dragPercentage
                                        } else {
                                            offset = newOffset
                                        }
                                    }
                                    .onEnded { value in
                                        // 检测是否为向下拖动手势，并且足够距离触发关闭
                                        if scale <= 1.0 && abs(value.translation.width) < abs(value.translation.height) && value.translation.height > 150 {
                                            onDismiss()
                                            return
                                        }
                                        
                                        // 如果是缩放状态，处理边界
                                        if scale > 1 {
                                            // 计算图片的实际大小
                                            let scaledWidth = geometry.size.width * scale
                                            let scaledHeight = geometry.size.height * scale
                                            
                                            // 计算最大允许的偏移量
                                            let maxOffsetX = (scaledWidth - geometry.size.width) / 2
                                            let maxOffsetY = (scaledHeight - geometry.size.height) / 2
                                            
                                            var newOffset = CGSize(
                                                width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height
                                            )
                                            
                                            // 限制偏移量在允许的范围内
                                            newOffset.width = min(maxOffsetX, max(-maxOffsetX, newOffset.width))
                                            newOffset.height = min(maxOffsetY, max(-maxOffsetY, newOffset.height))
                                            
                                            offset = newOffset
                                            lastOffset = newOffset
                                        } else {
                                            // 如果不是缩放状态，重置偏移量
                                            offset = .zero
                                            lastOffset = .zero
                                            
                                            // 恢复透明度
                                            UIApplication.shared.windows.first?.rootViewController?.view.alpha = 1.0
                                        }
                                    }
                            )
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let delta = value / lastScale
                                        lastScale = value
                                        
                                        // 限制缩放范围在0.5到3之间
                                        let newScale = scale * delta
                                        scale = min(3, max(1, newScale))
                                    }
                                    .onEnded { value in
                                        lastScale = 1.0
                                        
                                        // 如果缩放小于1，则恢复到1
                                        if scale < 1 {
                                            withAnimation {
                                                scale = 1
                                                offset = .zero
                                                lastOffset = .zero
                                            }
                                        } else if scale > 3 {
                                            // 如果缩放大于3，则限制为3
                                            scale = 3
                                        }
                                    }
                            )
                            .onTapGesture(count: 1) {
                                onSingleTap()
                            }
                            .onTapGesture(count: 2) {
                                withAnimation {
                                    if scale > 1 {
                                        // 如果已经放大，则恢复原始大小
                                        scale = 1
                                        offset = .zero
                                        lastOffset = .zero
                                    } else {
                                        // 否则放大到2倍
                                        scale = 2
                                    }
                                }
                            }
                            .onAppear {
                                isLoading = false
                            }
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        }
    }
}
