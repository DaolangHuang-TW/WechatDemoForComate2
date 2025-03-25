import SwiftUI

struct MomentCell: View {
    let moment: MomentItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 用户信息
            HStack(spacing: 12) {
                CachedImage(urlString: moment.sender!.avatar) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                Text(moment.sender!.nick)
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
            }
            
            // 内容
            if let content = moment.content {
                Text(content)
                    .font(.system(size: 15))
                    .lineLimit(6)
                    .padding(.top, 2)
            }
            
            // 图片
            if let images = moment.images, !images.isEmpty {
                ImageGridView(images: images)
                    .padding(.top, 4)
            }
            
            // 评论
            if let comments = moment.comments, !comments.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(comments.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 4) {
                            Text(comments[index].sender.nick)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(comments[index].content)
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(4)
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
