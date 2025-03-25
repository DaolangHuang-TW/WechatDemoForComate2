import SwiftUI

struct PreviewableImageView: View {
    let url: String
    let aspectRatio: CGFloat
    let width: CGFloat
    var onTap: () -> Void
    
    var body: some View {
        CachedImage(urlString: url) { image in
            image
                .resizable()
                .frame(width: width)
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    onTap()
                }
        } placeholder: {
            ProgressView()
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .clipped()
        .cornerRadius(4)
    }
}