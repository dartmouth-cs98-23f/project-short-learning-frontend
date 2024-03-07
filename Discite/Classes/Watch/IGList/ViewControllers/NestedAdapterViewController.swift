//
//  NestedAdapterViewController.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//
//  Adapted from IGListKit iOS Examples, NestedAdapterViewController.swift
//      https://github.com/Instagram/IGListKit/blob/main/Examples/Examples-iOS/IGListKitExamples/ViewControllers/NestedAdapterViewController.swift
//

import IGListKit
import UIKit

enum ViewControllerState: CaseIterable {
    case loading, loaded, error
}

final class NestedAdapterViewController: UIViewController, ListAdapterDataSource, ListAdapterDelegate {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(),
                           viewController: self,
                           workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var data = [1, 2, 3]
    var loading = false
    
    // TestView pass first sequence to Rep onAppear, Rep can pass here
    // let playlistQueue: [Playlist] = []
    
    var task: Task<Void, Error>?
    private var state: ViewControllerState = .loaded

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        
        adapter.dataSource = self
        adapter.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: ListAdapterDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if index == data.count - 2 && !loading {
            loading = true
            data.append(4)
            print("************* Loaded playlists. New sequence length: \(data.count) ***************")
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        print("objects for list adapter: \(data)")
        return data as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HorizontalSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

    deinit {
        task?.cancel()
    }
}
