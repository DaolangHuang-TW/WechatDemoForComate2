import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    // URLSession已经实现了这个方法，所以这里不需要额外实现
}
