//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Valenlyn Chua on 26/7/22.
//

import Foundation

struct EmojiArtModel {
    var background: Background = .blank
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Hashable {
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        let id: Int
        
        fileprivate init(_ text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    init() {}
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
   
}
