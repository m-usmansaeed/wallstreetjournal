//
//  NewsService.swift
//  Wall Street Journal
//  Copyright (c) Muhammad Usman Saeed
//
//  Using xCode 12.3, Swift 5.0
//  Running on macOS 12.6
//  Created on 11/28/23
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


import Foundation
import UIKit

final class NewsService {

    static let shared = NewsService()
    private init(){}
    
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey="
    static let apiKey = "66e94fc301ad47178fd776a743fa847b"
    private let finalUrl = baseURL + apiKey
    
    @MainActor
    @Sendable func downloadArticles() async throws -> [Article]? {
        do {
            let url = URL(string: finalUrl)!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(ApiResponse<[Article]>.self, from: data).articles
        } catch {
            return nil
        }
    }
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }else{
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    completed(nil)
                    return }
                
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            }
            
            task.resume()
        }
    }
    
}

