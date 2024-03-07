//
//  WorkingRangeSectionController.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//
//  Adapted from IGListKit iOS Examples, WorkingRangeSectionController.swift
//      https://github.com/Instagram/IGListKit/blob/main/Examples/Examples-iOS/IGListKitExamples/SectionControllers/WorkingRangeSectionController.swift
//

import IGListKit
import UIKit
import AVKit

final class WorkingRangeSectionController: ListSectionController, ListDisplayDelegate, ListWorkingRangeDelegate {
    private var height: Int?
    private var downloadedImage: UIImage?
    private var task: URLSessionDataTask?
    
    var visibleCell: EmbeddedVideoCell?
    
    // single VIDEO goes here
    private var video: Video?
    
    private var player: AVPlayer?
    var videoURLs = [URL]()
    var visibleIP: IndexPath?
    var aboutToBecomeInvisibleCell = -1
    
    private var urlString: String? {
        guard
            let size = collectionContext?.containerSize
            else { return nil }
        let width = Int(size.width)
        let height1 = Int(size.height)
        return "https://unsplash.it/" + width.description + "/" + height1.description
    }

    deinit {
        task?.cancel()
    }

    override init() {
        super.init()
        workingRangeDelegate = self
        displayDelegate = self
        
        for _ in 0..<2 {
            if let url = Bundle.main.url(forResource: "2", withExtension: "mp4") {
                videoURLs.append(url)
                
            } else {
                print("\tVideo resource not found.")
            }
        }
        
        visibleIP = IndexPath.init(row: 0, section: 0)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        let height: CGFloat = collectionContext?.containerSize.height ?? 0
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: EmbeddedVideoCell.self,
            for: self,
            at: index
        ) as? EmbeddedVideoCell else {
            // Handle the case where the dequeued cell is not of the expected type.
            return UICollectionViewCell()
        }
        
        if let url = video?.videoLink {
            let playerItem = AVPlayerItem(url: url)
            cell.configureWithPlayerItem(playerItem: playerItem)
        }
//        let playerItem = AVPlayerItem.init(url: videoURLs[index % 2])
//        cell.configureWithPlayerItem(playerItem: playerItem)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.video = object as? Video
    }
    
    // MARK: ListDisplayDelegate
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {

    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        if let cell = cell as? EmbeddedVideoCell {
            playVideoOnTheCell(cell: cell as EmbeddedVideoCell, index: index)
            
        } else {
            print("\tError in WorkingRangeSectionController: Couldn't play cell.")
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        if let cell = cell as? EmbeddedVideoCell {
            stopPlayBack(cell: cell, index: -1)
            
        } else {
            print("\tError in WorkingRangeSectionController: Couldn't pause cell.")
        }
    }
    
    func playVideoOnTheCell(cell: EmbeddedVideoCell, index: Int) {
        print("\t\tStarting playback for cell at index \(index)")
        cell.startPlaybackInPlayerView()
    }
    
    func stopPlayBack(cell: EmbeddedVideoCell, index: Int) {
        print("\t\tStopping playback for cell at index \(index)")
        cell.stopPlaybackInPlayerView()
        cell.hideOverlay()
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
    
    }

    // MARK: ListWorkingRangeDelegate
    
    // VIDEO
    private func configureCell(_ cell: EmbeddedVideoCell) {
        guard let videoURL = URL(string: "https://player.vimeo.com/external/518476405.hd.mp4?s=df881ca929fbcf84aaf4040445a581a1d8e2137c&profile_id=173&oauth2_token_id=57447761")
        else { return }
        
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        cell.configure(with: player)
        self.player = player
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        guard downloadedImage == nil,
            task == nil,
            let urlString = urlString,
            let url = URL(string: urlString)
            else { return }

        task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let image = UIImage(data: data) else {
                return print("Error downloading \(urlString): " + String(describing: error))
            }
            
            DispatchQueue.main.async {
                self.downloadedImage = image
//                if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? EmbeddedVideoCell {
//                    print("Setting video for cell at index 0...")
//                    self.configureCell(cell)
//                }
            }
//            DispatchQueue.main.async {
//                self.downloadedImage = image
//                if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? ImageCell {
//                    print("Setting image for cell at index 0...")
////                if let cell = self.collectionContext?.cellForItem(at: 1, sectionController: self) as? ImageCell {
//                    cell.setImage(image: image)
//                }
//            }
        }
        task?.resume()
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {}

}
