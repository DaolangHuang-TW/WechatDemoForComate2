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

struct ImageItem: Codable {
    let url: String
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
