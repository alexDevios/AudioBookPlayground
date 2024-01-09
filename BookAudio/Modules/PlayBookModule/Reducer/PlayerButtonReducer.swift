//
//  PlayerButtonReducer.swift
//  BookAudio
//
//  Created by alexdevios on 09.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerButtonReducer {
    enum PlayerButtonReducerAction: BoundariesAction {

        enum ViewAction: Equatable {
            case isEnabled(Bool)
            case play
            case pause
        }

        enum InternalAction: Equatable {
            case playOrPause
            case backward
            case gobackwardOn5Sec
            case goforwardOn10Sec
            case forward
        }

        enum DelegateAction: Equatable {
            case backward
            case gobackwardOn5Sec
            case goforwardOn10Sec
            case forward
            case isPlaying(Bool)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    struct PlayerButtonReducerState: Equatable {
        var isPlaying: Bool = false
        var isEnabled: Bool = false
    }

    var body: some Reducer<PlayerButtonReducerState, PlayerButtonReducerAction> {
        Reduce { state, action in
            switch action {
            case let .view(viewaction):
                switch viewaction {
                case .isEnabled(let isEnabled):
                    state.isEnabled = isEnabled
                    return .none
                case .play:
                    state.isPlaying = true
                    return .none
                case .pause:
                    state.isPlaying = false
                    return .none
                }
            case let .internal(action):
                switch action {
                case .playOrPause:
                    state.isPlaying.toggle()
                    return .run { [isPlaying = state.isPlaying] send in
                        await send(.delegate(.isPlaying(isPlaying)))
                    }
                case .backward:
                    return .run { send in
                        await send(.delegate(.backward))
                    }
                case .gobackwardOn5Sec:
                    return .run { send in
                        await send(.delegate(.gobackwardOn5Sec))
                    }
                case .goforwardOn10Sec:
                    return .run { send in
                        await send(.delegate(.goforwardOn10Sec))
                    }
                case .forward:
                    return .run { send in
                        await send(.delegate(.forward))
                    }
                }
            case .delegate(_):
                return .none
            }
        }
    }
}
