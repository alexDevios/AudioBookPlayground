//
//  BookButtonsView.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookButtonsView: View {
    let store: StoreOf<PlayerButtonReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(alignment: .center, spacing: 32.0) {
                Button(action: {
                    viewStore.send(.internal(.backward))
                }, label: {
                    Image(systemName: "backward.end.fill")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                })
                .disabled(!viewStore.isEnabled)
                .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                Button(action: {
                    viewStore.send(.internal(.gobackwardOn5Sec))
                }, label: {
                    Image(systemName: "gobackward.5")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.black)
                })
                .disabled(!viewStore.isEnabled)
                .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                Button(action: {
                    viewStore.send(.internal(.playOrPause))
                }, label: {
                    Image(systemName: !viewStore.isPlaying ? "play.fill" : "pause.fill")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.black)
                })
                .disabled(!viewStore.isEnabled)
                .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                Button(action: {
                    viewStore.send(.internal(.goforwardOn10Sec))
                }, label: {
                    Image(systemName: "goforward.10")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.black)
                })
                .disabled(!viewStore.isEnabled)
                .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                Button(action: {
                    viewStore.send(.internal(.forward))
                }, label: {
                    Image(systemName: "forward.end.fill")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                })
                .disabled(!viewStore.isEnabled)
                .opacity(viewStore.isEnabled ? 1.0 : 0.5)
            }
        }
    }
}
