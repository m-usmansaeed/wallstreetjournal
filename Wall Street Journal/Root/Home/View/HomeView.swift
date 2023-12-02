//
//  HomeView.swift
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

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        Group {
            switch viewModel.loadState {
            case .loading:
                Text("Loading")
                VStack {
                    ProgressView()
                }
            case .success:
                NavigationView {
                    
                    List(filteredArticles, id: \.id) { article in
                        NavigationLink {
                            DetailsView(article: article)
                        } label: {
                            ArticleCell(article: article)
                        }                        
                    }
                    .refreshable(action: viewModel.downloadArticles)
                    .searchable(text: $viewModel.searchText)
                    .navigationTitle("Wall Street Journal")
                }
            case .failed:
                VStack {
                    
                    Text("Failed to download articles")
                    Button("Retry") {
                        viewModel.loadState = .loading
                        Task {
                            try await Task.sleep(nanoseconds: 300_000_000)
                            await viewModel.downloadArticles()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .task(viewModel.downloadArticles)
    }
    
    
    var filteredArticles: [Article] {
        
        if let articles = viewModel.articles {
            
            if viewModel.searchText.isEmpty {
                return articles
            } else {
                return articles.filter { ($0.title ?? "").localizedCaseInsensitiveContains(viewModel.searchText) }
            }
        }else{
            return []
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
