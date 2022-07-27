//
//  EmojiArtModel.Background.swift
//  EmojiArt
//
//  Created by Valenlyn Chua on 26/7/22.
//

import Foundation

extension EmojiArtModel {
    
    enum Background {
        case blank
        case url(URL)
        case imageData(Data)
        
        var url: URL? {
            switch self {
                case .url(let url): return url
                default: return nil
            }
        }
        
        var imageData: Data? {
            switch self {
                case .imageData(let data): return data
                default: return nil
            }
        }
    }
}
