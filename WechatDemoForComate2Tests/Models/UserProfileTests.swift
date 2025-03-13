import Testing
import Foundation
@testable import WechatDemoForComate2

struct UserProfileTests {
    @Test
    func testUserProfileDecoding() throws {
        // Given
        let json = """
        {
            "profile-image": "https://example.com/profile.jpg",
            "avatar": "https://example.com/avatar.jpg",
            "nick": "TestUser",
            "username": "testuser"
        }
        """.data(using: .utf8)!

        // When
        let userProfile = try JSONDecoder().decode(UserProfile.self, from: json)

        // Then
        #expect(userProfile.profileImage == "https://example.com/profile.jpg")
        #expect(userProfile.avatar == "https://example.com/avatar.jpg")
        #expect(userProfile.nick == "TestUser")
        #expect(userProfile.username == "testuser")
    }
}

struct MomentItemTests {
    @Test
    func testMomentItemDecoding() throws {
        // Given
        let json = """
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
        """.data(using: .utf8)!

        // When
        let momentItem = try JSONDecoder().decode(MomentItem.self, from: json)

        // Then
        #expect(momentItem.content == "Test content")
        #expect(momentItem.images?.count == 1)
        #expect(momentItem.images?[0].url == "https://example.com/image.jpg")
        #expect(momentItem.sender?.username == "testuser")
        #expect(momentItem.comments?.count == 1)
        #expect(momentItem.comments?[0].content == "Test comment")
    }
}
