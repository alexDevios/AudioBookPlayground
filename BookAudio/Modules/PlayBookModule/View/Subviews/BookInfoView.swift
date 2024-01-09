//
//  BookInfoView.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookInfoView: View {
    let store: Store<BookInfoReducer.BookInfoReducerState, BookInfoReducer.BookInfoReducerAction>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: 16.0, content: {
                if !viewStore.isLoaded {
                    ShimmerView()
                        .frame(width: 250, height: 350)
                    ShimmerView()
                        .frame(width: 150, height: 16)
                    ShimmerView()
                        .frame(width: 250, height: 18)
                } else {
                    AsyncImage(url: URL(string: viewStore.bookImageUrl)) { image in
                        image
                            .resizable()
                            .frame(width: 250, height: 350, alignment: .center)
                    } placeholder: {
                        ShimmerView()
                            .frame(width: 250, height: 350)
                    }
                    Text("Key point \(viewStore.currentChapter) of \(viewStore.countOfChapters)".uppercased())
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                    Text(viewStore.title)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
            })
        }
    }
}
