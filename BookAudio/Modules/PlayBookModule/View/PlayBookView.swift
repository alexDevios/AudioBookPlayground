//
//  PlayBookView.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayBookView: View {
    let store: StoreOf<PlayBookReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
                Color.orange.opacity(0.05).ignoresSafeArea()
                VStack(alignment: .center, spacing: 0.0) {
                    BookInfoView(store: store.scope(state: \.bookInfo, action: PlayBookReducer.PlayBookReducerAction.bookInfoAction))
                    //
                    BookPlayerElementsView(store: store.scope(state: \.playerButtonElementsState, action: PlayBookReducer.PlayBookReducerAction.playerButtonActions))
                }
            })
            .onAppear(perform: {
                viewStore.send(.internal(.loadBook))
            })
        }
    }
}


#Preview {
    let store = Store(initialState: .initial) {
        PlayBookReducer()
    }
    return PlayBookView(store: store)
}
