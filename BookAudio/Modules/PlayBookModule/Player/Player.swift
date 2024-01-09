//
//  Player.swift
//  BookAudio
//
//  Created by alexdevios on 07.01.2024.
//

import AVFoundation

struct Player: Equatable {
    private var audioPlayer: AVPlayer

    init(_ audioPlayer: AVPlayer) {
        self.audioPlayer = audioPlayer
    }

    public func playAudio(_ rate: Float) {
        if audioPlayer.timeControlStatus != .playing {
            audioPlayer.play()
            audioPlayer.rate = rate
        }
    }

    public func pause() {
        if audioPlayer.timeControlStatus == .playing {
            audioPlayer.pause()
        }
    }

    public func getCurrentPlayingTime() -> Float64 {
        CMTimeGetSeconds(audioPlayer.currentTime())
    }

    public func backward() {
        let isPlaying = audioPlayer.timeControlStatus == .playing
        let selectedTime: CMTime = CMTimeMake(value: 0, timescale: 1000)
        let currentRate = audioPlayer.rate
        audioPlayer.pause()
        audioPlayer.seek(to: selectedTime)
        if isPlaying {
            audioPlayer.play()
            audioPlayer.rate = currentRate
        }
    }

    public func gobackwardOn5Sec() {
        let isPlaying = audioPlayer.timeControlStatus == .playing
        if let _ = audioPlayer.currentItem?.duration {
            let playerCurrentTime = getCurrentPlayingTime()
            var newTime = playerCurrentTime - Float64(5)
            if newTime < 0 { newTime = 0 }
            let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            let currentRate = audioPlayer.rate
            audioPlayer.pause()
            audioPlayer.seek(to: selectedTime)
            if isPlaying {
                audioPlayer.play()
                audioPlayer.rate = currentRate
            }
        }
    }

    public func goforwardOn10Sec() {
        let isPlaying = audioPlayer.timeControlStatus == .playing
        let currentRate = audioPlayer.rate
        if let duration = audioPlayer.currentItem?.duration {
            let playerCurrentTime = getCurrentPlayingTime()
            let newTime = playerCurrentTime + Float64(10)
            if newTime < CMTimeGetSeconds(duration) {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                audioPlayer.pause()
                audioPlayer.seek(to: selectedTime)
                if isPlaying {
                    audioPlayer.play()
                    audioPlayer.rate = currentRate
                }
            } else {
                audioPlayer.pause()
            }
        }
    }

    public func forward() {
        let duration = (audioPlayer.currentItem?.duration.seconds ?? 0.0)
        audioPlayer.seek(to: CMTime(seconds: Double(duration), preferredTimescale: 600))
    }

    public func changeRate(_ rateValue: Float) {
        audioPlayer.pause()
        audioPlayer.rate = rateValue
        let isPlaying = audioPlayer.timeControlStatus == .playing
        let currentRate = audioPlayer.rate
        if isPlaying {
            audioPlayer.play()
            audioPlayer.rate = currentRate
        }
    }

    public func updatePlayingTime(_ time: Float, isPlaying: Bool) {
        let currentRate = audioPlayer.rate
        let sec = CMTime(seconds: Double(time), preferredTimescale: 600)
        audioPlayer.seek(to: sec)
        audioPlayer.pause()
        if isPlaying {
            audioPlayer.play()
            audioPlayer.rate = currentRate
        }
    }
}
