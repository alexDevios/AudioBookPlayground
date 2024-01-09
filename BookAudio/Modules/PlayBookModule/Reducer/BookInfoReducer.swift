//
//  BookInfoReducer.swift
//  BookAudio
//
//  Created by alexdevios on 09.01.2024.
//

import ComposableArchitecture

@Reducer
struct BookInfoReducer {
    struct BookInfoReducerState: Equatable {
        var bookModel: BookRuntimeModel?
        var selectedId: String?
        var title: String {
            bookModel?.chapters.first(where: { $0.chapterId == selectedId })?.chapterTitle ?? ""
        }
        var currentChapter: Int {
            (bookModel?.chapters.firstIndex(where: { $0.chapterId == selectedId }) ?? 0) + 1
        }
        var countOfChapters: Int {
            bookModel?.chapters.count ?? 0
        }
        var bookImageUrl: String {
            bookModel?.bookImage ?? ""
        }
        var isLoaded: Bool {
            bookModel != nil
        }

        static let initial: Self = .init(bookModel: nil, selectedId: nil)
    }
    enum BookInfoReducerAction: Equatable {}

    var body: some Reducer<BookInfoReducer.BookInfoReducerState, BookInfoReducer.BookInfoReducerAction> {
        EmptyReducer()
    }
}
