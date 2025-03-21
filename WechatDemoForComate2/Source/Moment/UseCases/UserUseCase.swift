import Foundation

protocol UserUseCaseProtocol {
    func getUserProfile() async -> Result<UserProfile, Error>
    func getMoments() async -> Result<[MomentItem], Error>
}

class UserUseCase: UserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func getUserProfile() async -> Result<UserProfile, Error> {
        do {
            let profile = try await repository.fetchUserProfile()
            return .success(profile)
        } catch {
            return .failure(error)
        }
    }
    
    func getMoments() async -> Result<[MomentItem], Error> {
        do {
            let moments = try await repository.fetchMoments()
            return .success(moments)
        } catch {
            return .failure(error)
        }
    }
}
