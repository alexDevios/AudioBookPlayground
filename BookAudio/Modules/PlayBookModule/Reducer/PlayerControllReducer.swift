//
//  PlayerControllReducer.swift
//  BookAudio
//
//  Created by alexdevios on 08.01.2024.
//

import ComposableArchitecture
import AVFoundation
import Foundation

@Reducer
struct PlayerControllReducer {
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear(let audioUrl):
                return .run { sender in
                    guard let url = audioUrl.getUrl() else {
                        await sender(.failture)
                        return
                    }
                    let playerItem = AVPlayerItem(url: url)
                    let duration = try await playerItem.asset.load(.duration).seconds
                    let player = AVPlayer(playerItem: playerItem)
                    await sender(.playerIsReady(player: player, durationTime: Float(duration)))
                }
            case .playerIsReady(player: let player, durationTime: let duration):
                state.playerIsReady = true
                state.audioPlayer = Player(player)
                state.maxDuration = duration
                return .run { [playerIsReady = state.playerIsReady] sender in
                    await sender(.buttonActions(.view(.isEnabled(playerIsReady))))
                    await sender(.seekActions(.view(.isEnabled(isEnable: playerIsReady, fullDuration: duration))))
                    await sender(.seekActions(.view(.setCurrentPlayingTime(0.0))))
                }
            case .failture:
                state.playerIsReady = false
                return .run { [playerIsReady = state.playerIsReady] sender in
                    await sender(.buttonActions(.view(.isEnabled(playerIsReady))))
                    await sender(.seekActions(.view(.isEnabled(isEnable: playerIsReady, fullDuration: 0.0))))
                }
            case .playPrevious:
                return .none
            case .startTimer:
                state.timerIsOn = true
                state.audioPlayer?.playAudio(state.rate)
                return .run { sender in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await sender(.updateTime)
                    }
                }
                .cancellable(id: CancelID.timer)
            case .stopTimer:
                state.timerIsOn = false
                state.audioPlayer?.pause()
                return .cancel(id: CancelID.timer)
            case .updateTime:
                return .run { [state] send in
                    let time = Float(state.audioPlayer?.getCurrentPlayingTime() ?? 0.0)
                    await send(.seekActions(.view(.setCurrentPlayingTime(time))))
                    if time == state.maxDuration {
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask {
                                await send(.stopTimer)
                            }
                            group.addTask {
                                await send(.buttonActions(.view(.pause)))
                            }
                        }
                    }
                }
            case let .buttonActions(action):
                // MARK: - Handle actions of player buttons
                switch action {
                case .view(_), .internal(_):
                    return .none
                case let .delegate(delegateAction):
                    switch delegateAction {
                    case .backward:
//                        if (0...2).contains(Int(state.timePlaying)) {
//                            return .run { sender in
//                                await withTaskGroup(of: Void.self) { group in
//                                    group.addTask {
//                                        await sender(.buttonActions(.pause))
//                                    }
//                                    group.addTask {
//                                        await sender(.playPrevious)
//                                    }
//                                }
//                            }
//                        } else {
                            state.audioPlayer?.backward()
                            return .run { sender in
                                await sender(.updateTime)
                            }
//                        }
                    case .gobackwardOn5Sec:
                        state.audioPlayer?.gobackwardOn5Sec()
                        return .run { sender in
                            await sender(.updateTime)
                        }
                    case .goforwardOn10Sec:
                        state.audioPlayer?.goforwardOn10Sec()
                        return .run { sender in
                            await sender(.updateTime)
                        }
                    case .forward:
                        state.audioPlayer?.forward()
                        return .run { sender in
                            await sender(.updateTime)
                        }
                    case let .isPlaying(isPlaying):
                        if isPlaying {
                            return .run { sender in
                                await sender(.startTimer)
                            }
                        } else {
                            return .run { sender in
                                await withTaskGroup(of: Void.self) { group in
                                    group.addTask {
                                        await sender(.updateTime)
                                    }
                                    group.addTask {
                                        await sender(.stopTimer)
                                    }
                                }
                            }
                        }
                    }
                }
            case let .seekActions(action):
                switch action {
                case .view(_), .internal(_):
                    return .none
                case .delegate(let delegateAction):
                    switch delegateAction {
                    case .setRate(let rateValue):
                        state.audioPlayer?.changeRate(rateValue)
                        state.rate = rateValue
                        return .run {[state] sender in
                            await withTaskGroup(of: Void.self) { group in
                                if !state.timerIsOn {
                                    group.addTask {
                                        await sender(.startTimer)
                                    }
                                }
                                group.addTask {
                                    await sender(.buttonActions(.view(.play)))
                                }
                            }
                        }
                    case .setSeekTime(let sec):
                        state.audioPlayer?.updatePlayingTime(sec, isPlaying: state.timerIsOn)
                        return .run { sender in
                            await sender(.updateTime)
                        }
                    }
                }
            }
        }
        Scope(state: \.seekState, action: /PlayerControllReducer.Action.seekActions) {
            PlayerSeekReducer()._printChanges()
        }
        Scope(state: \.buttonElementsState, action: /PlayerControllReducer.Action.buttonActions) {
            PlayerButtonReducer()._printChanges()
        }
    }

    enum Action: Equatable {
        case onAppear(String)
        case failture
        case playerIsReady(player: AVPlayer, durationTime: Float)
        case startTimer
        case stopTimer
        case updateTime
        //
        case buttonActions(PlayerButtonReducer.PlayerButtonReducerAction)
        case seekActions(PlayerSeekReducer.PlayerSeekReducerAction)

        case playPrevious
    }

    struct State: Equatable {
        static func == (lhs: PlayerControllReducer.State, rhs: PlayerControllReducer.State) -> Bool {
            return lhs.playerIsReady == rhs.playerIsReady 
            && lhs.seekState == rhs.seekState
            && lhs.buttonElementsState == rhs.buttonElementsState
        }

        var buttonElementsState: PlayerButtonReducer.PlayerButtonReducerState = .init()
        var seekState: PlayerSeekReducer.PlayerSeekReducerState = .init()
        
        var audioPlayer: Player?
        var playerIsReady = false
        var timerIsOn = false
        var rate: Float = 1.0
        var maxDuration: Float = 0.0
    }
}
