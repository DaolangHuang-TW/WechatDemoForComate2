import Foundation
import UIKit
import CryptoKit

/// 图片缓存管理器
actor ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let monthInSeconds: TimeInterval = 30 * 24 * 60 * 60 // 30天的秒数
    
    private init() {
        // 获取应用的缓存目录
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")
        
        // 创建缓存目录
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // 启动时清理过期缓存
        Task {
            await cleanExpiredCache()
        }
    }
    
    /// 生成缓存文件路径
    private func cacheFilePath(for url: URL) -> URL {
        let urlString = url.absoluteString
        let hash = SHA256.hash(data: urlString.data(using: .utf8)!)
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        return cacheDirectory.appendingPathComponent(hashString)
    }
    
    /// 检查缓存是否过期
    private func isCacheExpired(at url: URL) -> Bool {
        guard let attributes = try? fileManager.attributesOfItem(atPath: url.path),
              let creationDate = attributes[.creationDate] as? Date else {
            return true
        }
        return Date().timeIntervalSince(creationDate) > monthInSeconds
    }
    
    /// 清理过期缓存
    func cleanExpiredCache() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) else {
            return
        }
        
        for file in files {
            if isCacheExpired(at: file) {
                try? fileManager.removeItem(at: file)
            }
        }
    }
    
    /// 清理所有缓存
    func clearAllCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    /// 从缓存加载图片
    func loadImageFromCache(url: URL) -> UIImage? {
        let filePath = cacheFilePath(for: url)
        
        // 如果缓存不存在或已过期，返回nil
        if !fileManager.fileExists(atPath: filePath.path) || isCacheExpired(at: filePath) {
            return nil
        }
        
        // 从缓存文件加载图片
        guard let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    /// 保存图片到缓存
    func saveImageToCache(_ image: UIImage, url: URL) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let filePath = cacheFilePath(for: url)
        try? data.write(to: filePath)
    }
}