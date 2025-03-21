import SwiftUI

struct PreviewableImageView: View {
    let url: String
    let aspectRatio: CGFloat
    let width: CGFloat
    var onTap: () -> Void
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .frame(width: width)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        onTap()
                    }
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
        .clipped()
        .cornerRadius(4)
    }
}