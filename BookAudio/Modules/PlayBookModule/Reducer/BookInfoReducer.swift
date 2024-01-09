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
            bookModel?.bookTitle ?? ""
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
    }
    enum BookInfoReducerAction: BoundariesAction {
        enum ViewAction: Equatable {
            case loadedBook(bookModel: BookRuntimeModel?, selectedId: String?)
        }
        enum InternalAction: Equatable {}
        enum DelegateAction: Equatable {}

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    var body: some Reducer<BookInfoReducer.BookInfoReducerState, BookInfoReducer.BookInfoReducerAction> {
        Reduce { state, action in
            switch action {
            case let .view(.loadedBook(bookModel: bookModel, selectedId: selectedId)):
                state.bookModel = bookModel
                state.selectedId = selectedId
                return .none
            }
        }
    }
}
