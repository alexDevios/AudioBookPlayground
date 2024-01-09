//
//  PlayBookApp.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct PlayBookApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store(initialState: .initial) {
                PlayBookReducer()
            }
            PlayBookView(store: store)
        }
    }
}
