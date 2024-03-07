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

    var data = [1, 2, 3]
    var loading = false
    
    // TestView pass first sequence to Rep onAppear, Rep can pass here
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
//        if index == data.count - 2 && !loading {
//            loading = true
//            data.append(4)
//            print("************* Loaded playlists. New sequence length: \(data.count) ***************")
//            adapter.performUpdates(animated: true, completion: nil)
//        }
        
        // Notify viewModel that playlist object at index appeared
        let playlistCount = viewModel.items.count
        viewModel.onItemAppear(index: index)
        
        // Check if viewModel loaded more
//        print("\tChecking if should perform updates...")
//        if viewModel.items.count > playlistCount {
//            print("\tNew playlist count is \(viewModel.items.count). Should update.")
//            adapter.performUpdates(animated: true, completion: nil)
//        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let playlists = viewModel.items
        return playlists as [ListDiffable]
        // return data as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HorizontalSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: SequenceLoadDelegate
    
    func sequenceFinishedLoading(success: Bool, error: Error?) {
        print("NestedVC received update in sequenceFinishedLoading")
        if success && error == nil {
            print("\tUpdate adapter with new items, count is \(viewModel.items.count).")
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
}

protocol SequenceLoadDelegate: AnyObject {
    func sequenceFinishedLoading(success: Bool, error: Error?)
}
