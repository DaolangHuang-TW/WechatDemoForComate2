import Foundation
@testable import WechatDemoForComate2

class MockUserRepository: UserRepositoryProtocol {
    var userProfile: Result<UserProfile, Error> = .failure(UserProfileError.networkError)
    var moments: Result<[MomentItem], Error> = .failure(UserProfileError.networkError)
    
    func fetchUserProfile() async throws -> UserProfile {
        switch userProfile {
        case .success(let profile):
            return profile
        case .failure(let error):
            throw error
        }
    }
    
    func fetchMoments() async throws -> [MomentItem] {
        switch moments {
        case .success(let moments):
            return moments
        case .failure(let error):
            throw error
        }
    }
}