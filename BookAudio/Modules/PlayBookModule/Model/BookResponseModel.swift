//
//  BookResponseModel.swift
//  BookAudio
//
//  Created by alexdevios on 06.01.2024.
//

import Foundation

struct BookResponseModel: Codable {
    var title: String?
    var imageUrl: String?
    var chapters: [Chapters]?

    struct Chapters: Codable {
        var chapterTitle: String?
        var chapterFileUrl: String?
    }
}
