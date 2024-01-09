//
//  BookSwitchPlayingView.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import SwiftUI

struct BookSwitchPlayingView: View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
            Capsule(style: .continuous)
                .fill(Color.white)
                .frame(width: 100, height: 50)
                .overlay(RoundedRectangle(cornerRadius: 27.5, style: .continuous)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1.0)
                )
            HStack(spacing: 5.0) {
                Button(action: {}, label: {
                    Image(systemName: "headphones")
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Circle())
                })
                Button(action: {}, label: {
                    Image(systemName: "list.dash")
                        .frame(width: 45, height: 45)
                        .foregroundColor(.black)
                    //                                .background(Color.blue)
                        .clipShape(Circle())
                })
            }
            .frame(width: 100, height: 50)
        })
    }
}
