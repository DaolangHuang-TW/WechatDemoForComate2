import Foundation

enum UserProfileError: Error {
    case invalidURL
    case networkError
    case decodingError
}

extension UserProfileError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "非法链接"
        case .networkError:
            return "网络错误"
        case .decodingError:
            return "解码错误"
        }
    }
}

protocol UserRepositoryProtocol {
    func fetchUserProfile() async throws -> UserProfile
    func fetchMoments() async throws -> [MomentItem]
}

class UserRepository: UserRepositoryProtocol {
    private let session: URLSessionProtocol
    private let baseURL = "https://apifoxmock.com"
    private let token = "JapJysb5u-n8yGO7__FEB"
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchUserProfile() async throws -> UserProfile {
        guard let url = URL(string: "\(baseURL)/m1/5946593-5634569-default/profile?apifoxToken=\(token)") else {
            throw UserProfileError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            print("error: \(error)")
            if error is DecodingError {
                throw UserProfileError.decodingError
            } else {
                throw UserProfileError.networkError
            }
        }
    }
    
    func fetchMoments() async throws -> [MomentItem] {
        guard let url = URL(string: "\(baseURL)/m1/5946593-5634569-default/moments?apifoxToken=\(token)") else {
            throw UserProfileError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            
            let moments = try decoder.decode([MomentItem].self, from: data)
            return moments.filter { moment in
                moment.sender != nil
            }
        } catch {
            print("error: \(error)")
            if error is DecodingError {
                throw UserProfileError.decodingError
            } else {
                throw UserProfileError.networkError
            }
        }
    }
}
