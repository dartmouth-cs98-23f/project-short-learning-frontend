//
//  ProgressDotsView.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import UIKit

class ProgressDotsView: UIView {
    var playlist: Playlist?
    var video: Video?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

//    init(video: Video?) {
//        self.video = video
//        self.playlist = video?.playlist
//        super.init(frame: .zero)
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        print("draw called")

        let currentIndex = 1
        let dotSpacing: CGFloat = 10
        let dotSizeSelected: CGFloat = 12
        let dotSizeUnselected: CGFloat = 8

        let centerY = rect.height / 2

        for index in 0..<3 {
            let centerX = CGFloat(index) * dotSpacing + dotSpacing / 2

            let circle = CAShapeLayer()
            circle.position = CGPoint(x: centerX, y: centerY)
            circle.bounds = CGRect(x: 0, y: 0, width: currentIndex == index ? dotSizeSelected : dotSizeUnselected, height: currentIndex == index ? dotSizeSelected : dotSizeUnselected)
            circle.cornerRadius = currentIndex == index ? dotSizeSelected / 2 : dotSizeUnselected / 2
            circle.fillColor = currentIndex == index ? UIColor.systemPurple.cgColor : UIColor.systemPurple.withAlphaComponent(0.5).cgColor

            self.layer.addSublayer(circle)
        }
    }

//    override func draw(_ rect: CGRect) {
//        guard 
//            let video = video,
//            let playlist = playlist,
//            let currentIndex = playlist.videos.firstIndex(where: { $0.id == video.id }) else {
//            return
//        }
//
//        let dotSpacing: CGFloat = 10
//        let dotSizeSelected: CGFloat = 12
//        let dotSizeUnselected: CGFloat = 8
//
//        let centerY = rect.height / 2
//
//        for index in 0..<playlist.videos.count {
//            let centerX = CGFloat(index) * dotSpacing + dotSpacing / 2
//
//            let circle = CAShapeLayer()
//            circle.position = CGPoint(x: centerX, y: centerY)
//            circle.bounds = CGRect(x: 0, y: 0, width: currentIndex == index ? dotSizeSelected : dotSizeUnselected, height: currentIndex == index ? dotSizeSelected : dotSizeUnselected)
//            circle.cornerRadius = currentIndex == index ? dotSizeSelected / 2 : dotSizeUnselected / 2
//            circle.fillColor = currentIndex == index ? UIColor.systemPurple.cgColor : UIColor.systemPurple.withAlphaComponent(0.5).cgColor
//
//            self.layer.addSublayer(circle)
//        }
//    }
}
