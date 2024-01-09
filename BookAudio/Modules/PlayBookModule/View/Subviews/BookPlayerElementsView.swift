//
//  BookPlayerElementsView.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookPlayerElementsView: View {
    let store: Store<PlayerControllReducer.State, PlayerControllReducer.Action>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: 40.0, content: {
                BookTimeLineView(store: store.scope(state: \.seekState,
                                                    action:  PlayerControllReducer.Action.seekActions))

                BookButtonsView(store: store.scope(state: \.buttonElementsState, action: PlayerControllReducer.Action.buttonActions))
                BookSwitchPlayingView()
            })
            .padding()
        }
    }
}
