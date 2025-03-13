import Foundation
@testable import WechatDemoForComate2

class MockUserUseCase: UserUseCaseProtocol {
    var userProfileResult: Result<UserProfile, Error> = .failure(UserProfileError.networkError)
    var momentsResult: Result<[MomentItem], Error> = .failure(UserProfileError.networkError)
    
    func getUserProfile() async -> Result<UserProfile, Error> {
        return userProfileResult
    }
    
    func getMoments() async -> Result<[MomentItem], Error> {
        return momentsResult
    }
}