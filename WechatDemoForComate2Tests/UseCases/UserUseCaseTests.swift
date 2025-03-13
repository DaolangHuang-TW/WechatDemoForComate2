import Testing
@testable import WechatDemoForComate2

struct UserUseCaseTests {
    @Test
    func testGetUserProfile_Success() async {
        // Given
        let mockRepository = MockUserRepository()
        let useCase = UserUseCase(repository: mockRepository)
        let expectedProfile = UserProfile(
            profileImage: "https://example.com/profile.jpg",
            avatar: "https://example.com/avatar.jpg",
            nick: "TestUser",
            username: "testuser"
        )
        mockRepository.userProfile = .success(expectedProfile)
        
        // When
        let result = await useCase.getUserProfile()
        
        // Then
        switch result {
        case .success(let profile):
            #expect(profile.profileImage == expectedProfile.profileImage)
            #expect(profile.avatar == expectedProfile.avatar)
            #expect(profile.nick == expectedProfile.nick)
            #expect(profile.username == expectedProfile.username)
        case .failure:
            #expect(Bool(false), "Expected success but got failure")
        }
    }
    
    @Test
    func testGetUserProfile_Failure() async {
        // Given
        let mockRepository = MockUserRepository()
        let useCase = UserUseCase(repository: mockRepository)
        mockRepository.userProfile = .failure(UserProfileError.networkError)
        
        // When
        let result = await useCase.getUserProfile()
        
        // Then
        switch result {
        case .success:
            #expect(Bool(false), "Expected failure but got success")
        case .failure(let error):
            #expect(error is UserProfileError)
            #expect((error as? UserProfileError) == .networkError)
        }
    }
    
    @Test
    func testGetMoments_Success() async {
        // Given
        let mockRepository = MockUserRepository()
        let useCase = UserUseCase(repository: mockRepository)
        let expectedMoments = [
            MomentItem(
                content: "Test content",
                images: [ImageItem(url: "https://example.com/image.jpg")],
                sender: Sender(
                    username: "testuser",
                    nick: "Test User",
                    avatar: "https://example.com/avatar.jpg"
                ),
                comments: [
                    Comment(
                        content: "Test comment",
                        sender: Sender(
                            username: "commenter",
                            nick: "Commenter",
                            avatar: "https://example.com/commenter.jpg"
                        )
                    )
                ]
            )
        ]
        mockRepository.moments = .success(expectedMoments)
        
        // When
        let result = await useCase.getMoments()
        
        // Then
        switch result {
        case .success(let moments):
            #expect(moments.count == 1)
            #expect(moments[0].content == expectedMoments[0].content)
            #expect(moments[0].images?.count == 1)
            #expect(moments[0].sender?.username == expectedMoments[0].sender?.username)
        case .failure:
            #expect(Bool(false), "Expected success but got failure")
        }
    }
    
    @Test
    func testGetMoments_Failure() async {
        // Given
        let mockRepository = MockUserRepository()
        let useCase = UserUseCase(repository: mockRepository)
        mockRepository.moments = .failure(UserProfileError.networkError)
        
        // When
        let result = await useCase.getMoments()
        
        // Then
        switch result {
        case .success:
            #expect(Bool(false), "Expected failure but got success")
        case .failure(let error):
            #expect(error is UserProfileError)
            #expect((error as? UserProfileError) == .networkError)
        }
    }
}
