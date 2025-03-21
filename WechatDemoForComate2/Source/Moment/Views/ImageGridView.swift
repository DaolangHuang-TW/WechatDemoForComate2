import SwiftUI

struct ImageGridView: View {
    let images: [ImageItem]
    @StateObject private var previewViewModel = ImagePreviewViewModel()
    
    private let columns: [GridItem]
    
    init(images: [ImageItem]) {
        self.images = images
        
        // 根据图片数量决定每行显示几张图片
        switch images.count {
        case 1:
            self.columns = [GridItem(.flexible())]
        case 2, 4:
            self.columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        default:
            self.columns = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        }
    }
    
    var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 40
        switch images.count {
        case 1: return screenWidth
        case 2, 4: return (screenWidth - 6)/2
        default: return (screenWidth - 12)/3
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(images.indices, id: \.self) { index in
                PreviewableImageView(
                    url: images[index].url,
                    aspectRatio: images.count == 1 ? 16/9 : 1,
                    width: itemWidth
                ) {
                    previewViewModel.showPreview(images: images, index: index)
                }
                .frame(height: images.count == 1 ? 200 : 100)
            }
        }
        .imagePreviewable(viewModel: previewViewModel)
    }
}
