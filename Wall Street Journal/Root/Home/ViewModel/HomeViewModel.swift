//
//  HomeViewModel.swift
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
import SwiftUI

enum LoadState {
    case loading
    case success
    case failed
}


class HomeViewModel: ObservableObject {
    
    @Published var articles: [Article]?
    @Published var loadState = LoadState.loading
    @Published var searchText = ""

    @MainActor
    @Sendable func downloadArticles() async {
        do {
            self.articles = try await NewsService.shared.downloadArticles()
            loadState = .success
        } catch {
            loadState = .failed
        }
    }
    
    
}
