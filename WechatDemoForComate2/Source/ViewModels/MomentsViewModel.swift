import Foundation
import Combine

@MainActor
class MomentsViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var moments: [MomentItem] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let useCase: UserUseCaseProtocol
    
    init(useCase: UserUseCaseProtocol = UserUseCase()) {
        self.useCase = useCase
    }
    
    func fetchData() async {
        isLoading = true
        error = nil
        
        await fetchUserProfile()
        await fetchMoments()
        
        isLoading = false
    }
    
    private func fetchUserProfile() async {
        let result = await useCase.getUserProfile()
        switch result {
        case .success(let profile):
            self.userProfile = profile
        case .failure(let error):
            self.error = (error as? UserProfileError)?.localizedDescription
        }
    }
    
    private func fetchMoments() async {
        let result = await useCase.getMoments()
        switch result {
        case .success(let moments):
            self.moments = moments
        case .failure(let error):
            self.error = (error as? UserProfileError)?.localizedDescription
        }
    }
}
