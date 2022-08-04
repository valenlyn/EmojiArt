//
//  ContentView.swift
//  EmojiArt
//
//  Created by Valenlyn Chua on 26/7/22.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    @State private var selectedEmojis = Set<EmojiArtModel.Emoji>()
    @State private var offset = CGSize.zero
    
    var documentBody: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                ForEach(document.emojis) { emoji in
                    VStack {
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                            .border((selectedEmojis.contains(emoji) ? .blue : .clear))
                            .gesture(drag(the: emoji))
                            .position(position(for: emoji, in: geometry))
                            .onTapGesture {
                                    if (selectedEmojis.contains(emoji)) {
                                        selectedEmojis.remove(emoji)
                                    } else {
                                        selectedEmojis.insert(emoji)
                                    }
                                }
                            .overlay(Group {
                                ZStack {
                                    Button(action: { delete(the: emoji) }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red).font(.title)
                                    }
                                        .opacity((selectedEmojis.contains(emoji) ? 1 : 0))
                                        .position(position(for: emoji, in: geometry))
                                        .padding(EdgeInsets(top: -fontSize(for: emoji) / 2, leading: fontSize(for: emoji) / 3, bottom: 0, trailing: 0))
                                }
                            })
                    }
                }
            }
            .gesture(pinch())
            .onDrop(of: [.plainText], isTargeted: nil) { providers, location in
                return drop(providers: providers, at: location, in: geometry)
            }
            .onTapGesture {
                selectedEmojis.removeAll()
            }
        }
    }
    
    private func delete(the emoji: EmojiArtModel.Emoji) {
        document.removeEmoji(emoji)
    }
    
    private func pinch() -> some Gesture {
       MagnificationGesture()
            .onChanged { value in
                selectedEmojis.forEach { emoji in
                    if let index = document.emojis.index(matching: emoji) {
                        document.scaleEmoji(document.emojis[index], by: value)
                    }
                }
            }
            .onEnded { value in
                selectedEmojis.removeAll()
            }
            
    }
    
    @GestureState var draggingEmoji: (offset: CGSize, emoji: EmojiArtModel.Emoji?) = (.zero, nil)
    
    private func drag(the emoji: EmojiArtModel.Emoji) -> some Gesture {
        DragGesture()
            .updating($draggingEmoji) { currentState, gestureState, transaction in
                let translation = currentState.translation
                gestureState = (translation, emoji)
            }
            .onChanged { state in
                selectedEmojis.forEach { emoji in
                    if let index = document.emojis.index(matching: emoji) {
                        document.moveEmoji(document.emojis[index], by: state.translation)
                    }
                }
            }
            .onEnded { state in
                selectedEmojis.forEach { emoji in
                    if let index = document.emojis.index(matching: emoji) {
                        document.moveEmoji(document.emojis[index], by: state.translation)
                    }
                }
                selectedEmojis.removeAll()
            }
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self) { string in
            if let emoji = string.first, emoji.isEmoji {
                document.addEmoji(String(emoji), at: convertToEmojiCoordinates(location, in: geometry), size: defaultEmojiFontSize)
            }
        }
    }
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
            let center = geometry.frame(in: .local).center
            return CGPoint(
                x: center.x + CGFloat(location.x),
                y: center.y + CGFloat(location.y)
            )
        }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: location.x - center.x,
            y: location.y - center.y
        )
        return (Int(location.x), Int(location.y))
    }
    
    
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "😖👻☀️⚽️ 🏀 🏈 ⚾️ 🥎 🎾 🏐 🏉 🥏 🎱 🪀 🏓 🏸 🏒 🏑 🥍 🏏 🪃 🥅 ⛳️ 🪁 🏹 🎣 🤿 🥊 🥋 🎽 🛹 🛼 🛷 ⛸ 🥌 🎿 ⛷ 🏂 🪂"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0)}, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}
