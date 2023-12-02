//
//  DetailsView.swift
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


import SwiftUI

struct DetailsView: View {
    
    @StateObject private var imageLoader = ImageLoader()
    @Environment(\.openURL) private var openURL
    
    let article: Article
    
    var body: some View {
        ScrollView {
            
            Image(uiImage: imageLoader.image ?? UIImage(systemName:"newspaper")!)
                .resizable()
                .scaledToFill()
            
            VStack(alignment: .leading, spacing: 20) {
                Text(article.title ?? "")
                    .font(.title)
                
                Text(article.description ?? "")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text(article.author ?? "")
                        .font(.headline.weight(.heavy))
                    
                    Text((article.publishedAt ?? Date()).formatted(date: .abbreviated, time: .standard))
                        .font(.headline)
                }
                
                Text(article.content ?? "")
            }
            .padding(.horizontal)
        }
        .onAppear(perform: {
            imageLoader.load(fromURLString: article.urlToImage ?? "")
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                openURL(URL(string: article.url ?? "https://images.wsj.net")!)
            } label: {
                Label("Open in your web browser", systemImage: "safari")
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(article: Article.mockData)
    }
}
