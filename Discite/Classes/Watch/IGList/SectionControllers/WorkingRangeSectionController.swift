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

final class WorkingRangeSectionController: ListSectionController, ListDisplayDelegate {
    private var video: Video?
    private var player: AVPlayer?
    
    var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }

    override init() {
        super.init()
        displayDelegate = self
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
        
        cell.configureWithVideo(video: video)
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
            stopPlayBack(cell: cell, index: index)
            
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
}
