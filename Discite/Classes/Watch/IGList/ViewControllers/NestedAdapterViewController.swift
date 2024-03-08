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

final class NestedAdapterViewController: 
    UIViewController, ListAdapterDataSource, ListAdapterDelegate, SequenceLoadDelegate {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(),
                           viewController: self,
                           workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var viewModel: SequenceViewModel
    
    // MARK: Initializers
    
    init(viewModel: SequenceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        
        adapter.dataSource = self
        adapter.delegate = self
        
        viewModel.loadDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: ListAdapterDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        // Notify viewModel that playlist object at index appeared
        viewModel.onItemAppear(index: index)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let playlists = viewModel.items
        return playlists as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HorizontalSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: SequenceLoadDelegate
    
    func sequenceFinishedLoading(success: Bool, error: Error?) {
        #if DEBUG
        print("NestedAdapterViewController received update in sequenceFinishedLoading")
        #endif
        
        if success && error == nil {
            print("\tUpdate adapter with new items, count is \(viewModel.items.count).")
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
}

protocol SequenceLoadDelegate: AnyObject {
    func sequenceFinishedLoading(success: Bool, error: Error?)
}
