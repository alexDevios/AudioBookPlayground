//
//  PlayerSeekReducer.swift
//  BookAudio
//
//  Created by alexdevios on 09.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerSeekReducer {
    struct PlayerSeekReducerState: Equatable {
        var rate: TrackRate = .x1
        var isEnabled = false
        var fullDuration: Float = 0.0
        var currentPlayingTime: Float = 0.0

        var endTime: String {
            if !isEnabled {
                return "--:--"
            }
            let formattedString = String(format: "%02d:%02d",
                                         Int((fullDuration / 60).truncatingRemainder(dividingBy: 60)),
                                         Int(fullDuration.truncatingRemainder(dividingBy: 60)))
            return formattedString
        }

        var currentPlaiyngTimeTitle: String {
            if !isEnabled {
                return "--:--"
            }
            let formattedString = String(format: "%02d:%02d",
                                         Int((currentPlayingTime / 60).truncatingRemainder(dividingBy: 60)),
                                         Int(currentPlayingTime.truncatingRemainder(dividingBy: 60)))
            return formattedString
        }

        enum TrackRate: Equatable {
            case x1
            case x1poit5
            case x2

            mutating func toggle() {
                switch self {
                case .x1:
                    self = .x1poit5
                case .x1poit5:
                    self = .x2
                case .x2:
                    self = .x1
                }
            }

            var title: String {
                switch self {
                case .x1:
                    return "Speed x1"
                case .x1poit5:
                    return "Speed x1.5"
                case .x2:
                    return "Speed x2"
                }
            }

            var rateValue: Float {
                switch self {
                case .x1:
                    return 1.0
                case .x1poit5:
                    return 1.5
                case .x2:
                    return 2.0
                }
            }
        }
    }

    enum PlayerSeekReducerAction: BoundariesAction {
        enum ViewAction: Equatable {
            case isEnabled(isEnable: Bool, fullDuration: Float)
            case setCurrentPlayingTime(Float)
        }

        enum InternalAction: Equatable {
            case toggleRate
        }

        enum DelegateAction: Equatable {
            case setRate(Float)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }


    var body: some Reducer<PlayerSeekReducerState, PlayerSeekReducerAction> {
        Reduce { state, action in
            switch action {
            case let .view(action):
                switch action {
                case .isEnabled(isEnable: let isEnable, fullDuration: let fullDuration):
                    state.isEnabled = isEnable
                    state.fullDuration = fullDuration
                    return .none
                case .setCurrentPlayingTime(let time):
                    state.currentPlayingTime = time
                    print(time)
                    return .none
                }
            case let .internal(action):
                switch action {
                case .toggleRate:
                    state.rate.toggle()
                    return .run { [rateValue = state.rate.rateValue] send in
                        await send(.delegate(.setRate(rateValue)))
                    }
                }
            case .delegate(_):
                return .none
            }
        }
    }
}
