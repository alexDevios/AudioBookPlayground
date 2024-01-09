//
//  BookRuntimeModel.swift
//  BookAudio
//
//  Created by alexdevios on 07.01.2024.
//

import Foundation

struct BookRuntimeModel: Equatable {
    private(set) var bookTitle: String
    private(set) var bookImage: String
    private(set) var chapters: [BookChaptersRuntimeModel]

    init(_ responseModel: BookResponseModel) {
        self.bookTitle = responseModel.title ?? ""
        self.bookImage = responseModel.imageUrl ?? ""
        self.chapters = responseModel.chapters?.map {
            BookChaptersRuntimeModel(chapterResponseModel: $0)
        } ?? []
    }
}

struct BookChaptersRuntimeModel: Equatable {
    let chapterId: String = UUID().uuidString
    private(set) var chapterTitle: String
    private(set) var chapterFileUrl: String

    init(chapterResponseModel model: BookResponseModel.Chapters) {
        self.chapterTitle = model.chapterTitle ?? ""
        self.chapterFileUrl = model.chapterFileUrl ?? ""
    }
}
