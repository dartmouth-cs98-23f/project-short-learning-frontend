//
//  HorizontalSectionController.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//
//  Adapted from IGListKit iOS Examples, HorizontalSectionController.swift
//      https://github.com/Instagram/IGListKit/blob/main/Examples/Examples-iOS/IGListKitExamples/SectionControllers/HorizontalSectionController.swift
//

import IGListKit
import UIKit

final class HorizontalSectionController: ListSectionController, ListAdapterDataSource, ListDisplayDelegate {
    
    // Each horizontal section is a playlist of videos
    private var playlist: Playlist?
    
    // private var number: Int?
    var visibleIP: IndexPath?

    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController,
                                  workingRangeSize: 2)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        displayDelegate = self
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: EmbeddedCollectionViewCell.self,
            for: self,
            at: index
        ) as? EmbeddedCollectionViewCell else {
            // Handle the case where the dequeued cell is not of the expected type
            return UICollectionViewCell()
        }
        
        adapter.collectionView = cell.collectionView
        return cell
    }

    override func didUpdate(to object: Any) {
        playlist = object as? Playlist
        // number = object as? Int
    }
    
    // MARK: ListDisplayDelegate
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }

    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
         
        if let cell = cell as? EmbeddedCollectionViewCell {
             let indexPaths = cell.collectionView.indexPathsForVisibleItems
             
             cell.collectionView.cellForItem(at: IndexPath(index: index))
             var cells = [Any]()
             for ip in indexPaths {
                 if let videoCell = cell.collectionView.cellForItem(at: ip) as? EmbeddedVideoCell {
                     cells.append(videoCell)
                 }
             }
             
             let cellCount = cells.count
             if cellCount == 0 { return }
             
             if cellCount == 1 {
                 if visibleIP != indexPaths[0] {
                     visibleIP = indexPaths[0]
                 }
                 
                 if let videoCell = cells.last! as? EmbeddedVideoCell {
                     videoCell.startPlaybackInPlayerView()
                 }
             }

         } else {
             print("\tCell couldn't be casted to an EmbeddedCollectionViewCell")
         }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {

        if let cell = cell as? EmbeddedCollectionViewCell {
            let indexPaths = cell.collectionView.indexPathsForVisibleItems

            cell.collectionView.cellForItem(at: IndexPath(index: index))
            var cells = [Any]()
            for ip in indexPaths {
                if let videoCell = cell.collectionView.cellForItem(at: ip) as? EmbeddedVideoCell {
                    cells.append(videoCell)
                }
            }
            
            let cellCount = cells.count
            if cellCount == 0 { return }
            
            if cellCount == 1 {
                if visibleIP != indexPaths[0] {
                    visibleIP = indexPaths[0]
                }
                
                if let videoCell = cells.last! as? EmbeddedVideoCell {
                    videoCell.stopPlaybackInPlayerView()
                    videoCell.hideOverlay()
                }
            }

        } else {
            print("\tError in HorizontalSectionController: Cell couldn't be casted to an EmbeddedCollectionViewCell")
        }
    }
    
    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let playlist = playlist else { return [] }
        return playlist.videos as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return WorkingRangeSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
