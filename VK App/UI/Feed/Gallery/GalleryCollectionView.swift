//
//  GalleryCollectionView.swift
//  VK App
//
//  Created by Алексей Воронов on 20.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

class GalleryCollectionView: UICollectionView {
    var photos: [FeedCellPhotoAttachementViewModel] = [] {
        didSet {
            contentOffset = .zero
            reloadData()
        }
    }
    
    init() {
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = UIColor.white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        
        if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GalleryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageURLString: photos[indexPath.row].photoURLString)
        return cell
    }
}

extension GalleryCollectionView: UICollectionViewDelegate {
}

extension GalleryCollectionView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAt indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.item].width
        let height = photos[indexPath.item].height
        
        return CGSize(width: width, height: height)
    }
}
