//
//  BookTimeLineView.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookTimeLineView: View {
    let store: Store<PlayerSeekReducer.PlayerSeekReducerState, PlayerSeekReducer.PlayerSeekReducerAction>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16.0) {
                HStack {
                    Text(viewStore.currentPlaiyngTimeTitle)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                        .frame(width: 40)
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
                        Capsule()
                            .fill(Color.black.opacity(0.06))
                            .frame(height: 4)
                            .disabled(!viewStore.isEnabled)
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        viewStore.send(.internal(.seekLineWidth(Float(geometry.frame(in: .global).width))))
                                    }
                            })
                            .opacity(viewStore.isEnabled ? 1.0 : 0.5)

                        Capsule()
                            .fill(Color.blue)
                            .frame(width: CGFloat(
                                !viewStore.seekLineTrackTime.isFinite ? 0 : viewStore.seekLineTrackTime), height: 4)
                            .disabled(!viewStore.isEnabled)
                            .opacity(viewStore.isEnabled ? 1.0 : 0.5)

                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                            .offset(x: CGFloat(viewStore.seekLineTrackTime) - 5)
                            .gesture(DragGesture().onChanged({ value in
                                viewStore.send(.internal(.setSeekTime(value.location)))
                            }))
                            .disabled(!viewStore.isEnabled)
                            .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                    })
                    Text(viewStore.endTime)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .opacity(viewStore.isEnabled ? 1.0 : 0.5)
                        .frame(width: 40)
                }
                Button(action: {
                    viewStore.send(.internal(.toggleRate))
                }, label: {
                    Text(viewStore.rate.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.all, 8.0)
                        .foregroundColor(.black)
                })
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
                .disabled(!viewStore.isEnabled)
                .opacity(viewStore.isEnabled ? 1.0 : 0.5)
            }
        }
    }
}
