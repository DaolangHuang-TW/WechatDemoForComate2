import Foundation

struct UserProfile: Codable {
    let profileImage: String
    let avatar: String
    let nick: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile-image"
        case avatar
        case nick
        case username
    }
}

struct MomentItem: Codable, Identifiable {
    let id = UUID()
    let content: String?
    let images: [ImageItem]?
    let sender: Sender?
    let comments: [Comment]?
    
    enum CodingKeys: String, CodingKey {
        case content
        case images
        case sender
        case comments
    }
}

struct ImageItem: Codable, Identifiable {
    let id = UUID()
    let url: String
    var hdUrl: String? // 高清图片URL，如果为nil则使用url作为高清图
    
    enum CodingKeys: String, CodingKey {
        case url
        case hdUrl = "hd_url"
    }
}

struct Sender: Codable {
    let username: String
    let nick: String
    let avatar: String
}

struct Comment: Codable, Identifiable {
    let id = UUID()
    let content: String
    let sender: Sender
    
    enum CodingKeys: String, CodingKey {
        case content
        case sender
    }
}
