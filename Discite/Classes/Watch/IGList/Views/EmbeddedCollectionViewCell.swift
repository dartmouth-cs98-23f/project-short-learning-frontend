//
//  EmbeddedCollectionViewCell.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//
//  From: IGListKit iOS Examples, EmbeddedCollectionViewCell.swift
//      https://github.com/Instagram/IGListKit/blob/main/Examples/Examples-iOS/IGListKitExamples/Views/EmbeddedCollectionViewCell.swift
//

import IGListKit
import UIKit

final class EmbeddedCollectionViewCell: UICollectionViewCell {

    var visibleIndex: IndexPath?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        self.contentView.addSubview(view)
        return view
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("EmbeddedCollectionViewCell did scroll")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
        collectionView.isPagingEnabled = true
    }
}
