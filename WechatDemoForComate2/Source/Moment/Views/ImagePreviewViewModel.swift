import SwiftUI

class ImagePreviewViewModel: ObservableObject {
    @Published var isShowingPreview = false
    @Published var selectedImages: [ImageItem] = []
    @Published var selectedIndex: Int = 0
    
    // 打开预览
    func showPreview(images: [ImageItem], index: Int) {
        self.selectedImages = images
        self.selectedIndex = index
        self.isShowingPreview = true
    }
    
    // 关闭预览
    func hidePreview() {
        self.isShowingPreview = false
    }
}

// 图片预览修饰器，可以应用于任何视图
struct ImagePreviewModifier: ViewModifier {
    @ObservedObject var viewModel: ImagePreviewViewModel
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $viewModel.isShowingPreview) {
                ImagePreviewView(
                    images: viewModel.selectedImages,
                    initialIndex: viewModel.selectedIndex
                )
                .edgesIgnoringSafeArea(.all)
            }
    }
}

// 扩展View，添加预览功能
extension View {
    func imagePreviewable(viewModel: ImagePreviewViewModel) -> some View {
        self.modifier(ImagePreviewModifier(viewModel: viewModel))
    }
}