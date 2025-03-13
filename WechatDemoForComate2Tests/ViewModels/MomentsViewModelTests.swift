import Testing
@testable import WechatDemoForComate2

@MainActor
struct MomentsViewModelTests {
    @Test
    func testFetchData_Success() async {
        // Given
        let mockUseCase = MockUserUseCase()
        let viewModel = MomentsViewModel(useCase: mockUseCase)
        
        let expectedProfile = UserProfile(
            profileImage: "https://example.com/profile.jpg",
            avatar: "https://example.com/avatar.jpg",
            nick: "TestUser",
            username: "testuser"
        )
        
        let expectedMoments = [
            MomentItem(
                content: "Test content",
                images: [ImageItem(url: "https://example.com/image.jpg")],
                sender: Sender(
                    username: "testuser",
                    nick: "Test User",
                    avatar: "https://example.com/avatar.jpg"
                ),
                comments: []
            )
        ]
        
        mockUseCase.userProfileResult = .success(expectedProfile)
        mockUseCase.momentsResult = .success(expectedMoments)
        
        // When
        await viewModel.fetchData()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.userProfile?.username == expectedProfile.username)
        #expect(viewModel.moments.count == 1)
        #expect(viewModel.moments[0].content == expectedMoments[0].content)
    }
    
    @Test
    func testFetchData_ProfileError() async {
        // Given
        let mockUseCase = MockUserUseCase()
        let viewModel = MomentsViewModel(useCase: mockUseCase)
        
        mockUseCase.userProfileResult = .failure(UserProfileError.networkError)
        mockUseCase.momentsResult = .success([])
        
        // When
        await viewModel.fetchData()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == "网络错误")
        #expect(viewModel.userProfile == nil)
    }
    
    @Test
    func testFetchData_MomentsError() async {
        // Given
        let mockUseCase = MockUserUseCase()
        let viewModel = MomentsViewModel(useCase: mockUseCase)
        
        let expectedProfile = UserProfile(
            profileImage: "https://example.com/profile.jpg",
            avatar: "https://example.com/avatar.jpg",
            nick: "TestUser",
            username: "testuser"
        )
        
        mockUseCase.userProfileResult = .success(expectedProfile)
        mockUseCase.momentsResult = .failure(UserProfileError.networkError)
        
        // When
        await viewModel.fetchData()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == "网络错误")
        #expect(viewModel.userProfile?.username == expectedProfile.username)
        #expect(viewModel.moments.isEmpty)
    }
}
