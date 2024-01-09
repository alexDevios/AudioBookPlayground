//
//  PlayBookReducer.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayBookReducer {
    var body: some Reducer<PlayBookReducer.PlayBookReducerState, PlayBookReducer.PlayBookReducerAction> {
        Reduce { state, action in
            switch action {
            case .loadBook:
                state.bookModel = nil
                state.selectedChapter = nil
                state.bookIsLoaded = false
                return .run { send in
                    let url = "https://d85e67e1340943f5baee67c933f121f1.api.mockbin.io/"
                    let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
                    guard let responseModel = try? JSONDecoder().decode(BookResponseModel.self, from: data) else {
                        await send(.emptyBook)
                        return
                    }
                    await send(.bookLoaded(.init(responseModel)))
                }
            case .bookLoaded(let bookModel):
                state.bookModel = bookModel
                state.selectedChapter = bookModel.chapters.first
                state.bookIsLoaded = true
                return .run { [selectedChapter = state.selectedChapter] send in
                    await send(.bookInfoAction(.view(.loadedBook(bookModel: bookModel, selectedId: selectedChapter?.chapterId))))
                    await send(.playerButtonActions(.onAppear(selectedChapter?.chapterFileUrl ?? "")))
                }
            case .emptyBook:
                state.bookModel = nil
                state.selectedChapter = nil
                state.bookIsLoaded = false
                return .none
            case .showChapterList(let isChapterShown):
                state.selectedChapterList = isChapterShown
                return .none
            case .playerButtonActions(_):
                return .none
            case .bookInfoAction(_):
                return .none
            }
        }
        Scope(state: \.bookInfo, action: /PlayBookReducerAction.bookInfoAction) {
            BookInfoReducer()._printChanges()
        }
        Scope(state: \.playerButtonElementsState, action: /PlayBookReducerAction.playerButtonActions) {
            PlayerControllReducer()._printChanges()
        }
    }

    enum PlayBookReducerAction: Equatable {
        case loadBook
        case bookLoaded(BookRuntimeModel)
        case emptyBook
        case showChapterList(Bool)
        case playerButtonActions(PlayerControllReducer.Action)
        case bookInfoAction(BookInfoReducer.BookInfoReducerAction)
    }

    struct PlayBookReducerState: Equatable {
        var playerButtonElementsState: PlayerControllReducer.State = .init()
        var bookInfo: BookInfoReducer.BookInfoReducerState = .init()
        var bookIsLoaded = false
        var selectedChapterList = false
        var bookModel: BookRuntimeModel?
        var selectedChapter: BookChaptersRuntimeModel?
    }
}

extension String {
    func getUrl() -> URL? {
        return URL(string: self)
    }
}
