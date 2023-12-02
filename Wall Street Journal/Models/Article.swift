//
//  Article.swift
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

struct ApiResponse<T: Codable> : Codable {
    let status : String?
    let totalResults : Int?
    let articles : T?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        articles = try values.decodeIfPresent(T.self, forKey: .articles)
    }

}

struct Article: Codable, Identifiable {
    let id = UUID().uuidString
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : Date?
    let content : String?
    
    enum CodingKeys: String, CodingKey {
        
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
    
    init(author: String, title: String,
         description: String, url: String,
         urlToImage: String, publishedAt: Date, content: String) {
        
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
        publishedAt = try values.decodeIfPresent(Date.self, forKey: .publishedAt)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }
    
    
    static let mockData = Article(
        author: "wsj",
        title: "Musk Visits Amid Criticism Over Content on X...",
        description: "Billionaire visits kibbutz attacked last month; is scheduled to meet with Israeli president",
        url: "https://www.wsj.com/world/middle-east/elon-musk-visits-israel-amid-criticism-over-antisemitic-content-on-x-436e7d40",
        urlToImage: "https://images.wsj.net/im-892024/social",
        publishedAt: Date(),
        content: "Elon Musk Visits Israel Amid Criticism Over Antisemitic Content on XBy Nov. 27, 2023 7:22 am ET\r\nElon Musk visited an Israeli community attacked by Hamas last month, and was scheduled to meet the cou… [+964 chars]")

}
