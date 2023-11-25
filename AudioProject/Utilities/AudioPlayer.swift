//
//  AudioPlayer.swift
//  AudioProject
//
//  Created by ahmed rajib on 23/11/23.
//

import Foundation
import AVFoundation

final class Player {
    
    static var share = Player()
    private var player = AVPlayer()
    
    private init() {}
    
    func play(url: URL) {
        player = AVPlayer(url: url)
        player.allowsExternalPlayback = true
        player.appliesMediaSelectionCriteriaAutomatically = true
        player.automaticallyWaitsToMinimizeStalling = true
        player.volume = 1
        player.play()
    }
}
