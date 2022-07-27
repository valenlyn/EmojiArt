//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Valenlyn Chua on 26/7/22.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
