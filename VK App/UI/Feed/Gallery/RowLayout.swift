//
//  RowLayout.swift
//  VK App
//
//  Created by Алексей Воронов on 20.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

protocol RowLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, photoAt indexPath: IndexPath) -> CGSize
}

class RowLayout: UICollectionViewLayout {
    weak var delegate: RowLayoutDelegate!
    
    static var numberOfRows = 1
    fileprivate var cellPadding: CGFloat = 8
    
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    
    fileprivate var contentWidth: CGFloat = 0
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        contentWidth = 0
        cache.removeAll()
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        var photos: [CGSize] = []
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAt: indexPath)
            photos.append(photoSize)
        }
        
        let superviewWidth = collectionView.frame.width
        
        guard var rowHeight = RowLayout.rowHeightCounter(superviewWidth: superviewWidth,
                                               photosArray: photos) else { return }
        
        rowHeight /= CGFloat(RowLayout.numberOfRows)
        
        let photosRatios = photos.map { $0.height / $0.width }
        
        var yOffsets: [CGFloat] = []
        for row in 0 ..< RowLayout.numberOfRows {
            yOffsets.append(CGFloat(row) * rowHeight)
        }
        
        var xOffsets = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        
        var row = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = photosRatios[indexPath.item]
            let width = rowHeight / ratio
            
            let frame = CGRect(x: xOffsets[row], y: yOffsets[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffsets[row] += width
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    static func rowHeightCounter(superviewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        
        let photoWithMinRatio = photosArray.min { (first, second) -> Bool in
            (first.height / first.width) < (second.height / second.width)
        }
        
        guard let myPhotoWithMinRatio = photoWithMinRatio else { return nil }
        
        let difference = superviewWidth / myPhotoWithMinRatio.width
        
        rowHeight = myPhotoWithMinRatio.height * difference
        
        rowHeight *= CGFloat(RowLayout.numberOfRows)
        return rowHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attribute in cache where attribute.frame.intersects(rect) {
            visibleLayoutAttributes.append(attribute)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
