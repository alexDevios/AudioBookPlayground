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
            case let .view(action):
                switch action {
                case .bookIsLoaded(let model):
                    state.bookModel = model
                    state.selectedChapter = model.chapters.first
                    state.bookIsLoaded = true
                    state.bookInfo = .init(bookModel: model, selectedId: model.chapters.first?.chapterId)
                    state.playerButtonElementsState = .init(buttonElementsState: .initial, seekState: .initial, audioUrl: model.chapters.first?.chapterFileUrl)
                    return .run { send in
                        await send(.playerButtonActions(.onAppear))
                    }
                case .emptyBook:
                    state.bookModel = nil
                    state.selectedChapter = nil
                    state.bookIsLoaded = false
                    state.bookInfo = .initial
                    state.playerButtonElementsState = .initial
                    return .run { send in
                        await send(.playerButtonActions(.failture))
                    }
                }
            case let .internal(action):
                switch action {
                case .loadBook:
                    state.bookModel = nil
                    state.selectedChapter = nil
                    state.bookIsLoaded = false
                    return .run { send in
                        let url = "https://d85e67e1340943f5baee67c933f121f1.api.mockbin.io/"
                        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
                        guard let responseModel = try? JSONDecoder().decode(BookResponseModel.self, from: data) else {
                            await send(.view(.emptyBook))
                            return
                        }
                        await send(.view(.bookIsLoaded(.init(responseModel))))
                    }
                case .showChapterList(_):
                    return .none
                }
            case .delegate(_), .playerButtonActions(_), .bookInfoAction(_):
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

    enum PlayBookReducerAction: BoundariesAction {
        enum ViewAction: Equatable {
            case bookIsLoaded(BookRuntimeModel)
            case emptyBook
        }

        enum InternalAction: Equatable {
            case loadBook
            case showChapterList(Bool)
//            case playerButtonActions(PlayerControllReducer.Action)
//            case bookInfoAction(BookInfoReducer.BookInfoReducerAction)
        }

        enum DelegateAction: Equatable {}

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)

        // actions залишив тут, через проблему створення Scope (коли actions знаходяться в InternalActions)
        case playerButtonActions(PlayerControllReducer.Action)
        case bookInfoAction(BookInfoReducer.BookInfoReducerAction)
    }

    struct PlayBookReducerState: Equatable {
        var playerButtonElementsState: PlayerControllReducer.State
        var bookInfo: BookInfoReducer.BookInfoReducerState
        var bookIsLoaded = false
        var selectedChapterList = false
        var bookModel: BookRuntimeModel?
        var selectedChapter: BookChaptersRuntimeModel?

        static let initial: Self = .init(playerButtonElementsState: .initial, bookInfo: .initial)
    }
}

extension String {
    func getUrl() -> URL? {
        return URL(string: self)
    }
}
