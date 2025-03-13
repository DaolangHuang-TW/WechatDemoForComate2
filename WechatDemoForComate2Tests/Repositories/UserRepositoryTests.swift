import Testing
import Foundation
@testable import WechatDemoForComate2

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data ?? Data(), response)
    }
}

struct UserRepositoryTests {
    @Test
    func testFetchUserProfile_Success() async throws {
        // Given
        let mockSession = MockURLSession()
        let repository = UserRepository(session: mockSession)
        let jsonData = """
        {
            "profile-image": "https://example.com/profile.jpg",
            "avatar": "https://example.com/avatar.jpg",
            "nick": "TestUser",
            "username": "testuser"
        }
        """.data(using: .utf8)!
        mockSession.data = jsonData

        // When
        let profile = try await repository.fetchUserProfile()

        // Then
        #expect(profile.profileImage == "https://example.com/profile.jpg")
        #expect(profile.avatar == "https://example.com/avatar.jpg")
        #expect(profile.nick == "TestUser")
        #expect(profile.username == "testuser")
    }

    @Test
    func testFetchUserProfile_NetworkError() async {
        // Given
        let mockSession = MockURLSession()
        let repository = UserRepository(session: mockSession)
        mockSession.error = NSError(domain: "NetworkError", code: -1, userInfo: nil)

        // When/Then
        do {
            _ = try await repository.fetchUserProfile()
            #expect(Bool(false), "Expected NetworkError to be thrown")
        } catch {
            #expect(error is UserProfileError)
            #expect((error as? UserProfileError) == .networkError)
        }
    }

    @Test
    func testFetchMoments_Success() async throws {
        // Given
        let mockSession = MockURLSession()
        let repository = UserRepository(session: mockSession)
        let jsonData = """
        [
            {
                "content": "Test content",
                "images": [{"url": "https://example.com/image.jpg"}],
                "sender": {
                    "username": "testuser",
                    "nick": "Test User",
                    "avatar": "https://example.com/avatar.jpg"
                },
                "comments": [
                    {
                        "content": "Test comment",
                        "sender": {
                            "username": "commenter",
                            "nick": "Commenter",
                            "avatar": "https://example.com/commenter.jpg"
                        }
                    }
                ]
            }
        ]
        """.data(using: .utf8)!
        mockSession.data = jsonData

        // When
        let moments = try await repository.fetchMoments()

        // Then
        #expect(moments.count == 1)
        #expect(moments[0].content == "Test content")
        #expect(moments[0].images?.count == 1)
        #expect(moments[0].images?[0].url == "https://example.com/image.jpg")
        #expect(moments[0].sender?.username == "testuser")
        #expect(moments[0].comments?.count == 1)
        #expect(moments[0].comments?[0].content == "Test comment")
    }

    @Test
    func testFetchMoments_NetworkError() async {
        // Given
        let mockSession = MockURLSession()
        let repository = UserRepository(session: mockSession)
        mockSession.error = NSError(domain: "NetworkError", code: -1, userInfo: nil)

        // When/Then
        do {
            _ = try await repository.fetchMoments()
            #expect(Bool(false), "Expected NetworkError to be thrown")
        } catch {
            #expect(error is UserProfileError)
            #expect((error as? UserProfileError) == .networkError)
        }
    }
}
