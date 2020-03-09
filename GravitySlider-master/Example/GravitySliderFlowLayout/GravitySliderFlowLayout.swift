//
//  GravitySliderFlowLayout.swift
//  GravitySliderExample
//
//  Created by Artem Tevosyan on 9/27/17.
//  Copyright © 2017 Artem Tevosyan. All rights reserved.
//

import Foundation
import UIKit

open class GravitySliderFlowLayout: UICollectionViewFlowLayout {
    
    let lineSpacingArgument: CGFloat = -2.5
    private var lastCollectionViewSize: CGSize = CGSize.zero
    private var period: CGFloat { return (collectionView?.bounds.width ?? 0) * 1.0}//0.86 }
    private var periodH: CGFloat { return (collectionView?.bounds.height ?? 0) * 1.0}//0.86 }

    public init(with itemSize: CGSize) {
        super.init()
//        self.scrollDirection = .horizontal
        self.scrollDirection = .vertical

        self.itemSize = itemSize
        self.minimumLineSpacing = 10;//itemSize.width / lineSpacingArgument
        self.minimumInteritemSpacing = 10
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(for scrollDirection: UICollectionViewScrollDirection, with collectionViewSize: CGSize) {
        guard collectionViewSize != lastCollectionViewSize else { return }
        self.lastCollectionViewSize = collectionViewSize
        self.scrollDirection = scrollDirection
//        switch scrollDirection {
//        case .horizontal: sectionInset = UIEdgeInsets(top: 0.0, left: collectionViewSize.width / 2 - itemSize.width / 2, bottom: 0.0, right: collectionViewSize.width / 2 - itemSize.width / 2)
//        case .vertical: sectionInset = UIEdgeInsets(top: collectionViewSize.height / 2 - itemSize.height / 2, left: 0, bottom: collectionViewSize.height / 2 - itemSize.height / 2, right: 0)
//        }
    }
    
    override open func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        self.setup(for: self.scrollDirection, with: collectionView.bounds.size)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        
        var targetRect = CGRect()
        switch scrollDirection {
        case .horizontal:
            targetRect.origin = CGPoint(x: rect.origin.x - rect.width / 2, y: rect.origin.y)

            targetRect.size = CGSize(width: rect.width * 2, height: rect.height)
            guard let collectionView = collectionView, let attributes = super.layoutAttributesForElements(in: targetRect) else { return nil }
            for attribute in attributes {
                //cellCenterX
                let cellX = collectionView.convert(attribute.center, to: nil).x
                
                let difference = collectionView.center.x - cellX
                
                let zIndexValue = -pow(abs(difference)/collectionView.frame.size.width, 2.0) + 1.0
                let scaleFactor = -pow((difference / 1.8)/collectionView.frame.size.width * 2.0, 2.0) + 1.0
                
                let numPeriods = floor(Double(cellX / period))
                let adjustment = CGFloat(numPeriods) * period
                let relativeDistanceFromCenter = collectionView.center.x - (cellX - adjustment)
                let centerProximityMagnitude = sinDistributor(x: cellX, period: period, xOffset: collectionView.center.x)
                
                var transform = CATransform3DIdentity
                let distanceFromCenter = fabs(collectionView.center.x - cellX)

                //transform = CATransform3DTranslate(transform, <#T##tx: CGFloat##CGFloat#>, <#T##ty: CGFloat##CGFloat#>, <#T##tz: CGFloat##CGFloat#>)
                
                //transform = CATransform3DTranslate(transform, relativeDistanceFromCenter - adjustment + centerProximityMagnitude * itemSize.width*0.6, 0.0, 0.0)

                print(attribute.indexPath.item);
                print(cellX)
                
                
                if cellX < itemSize.width * 0.5 {
                    let yDelta = getXDelta(x: cellX)
                    transform = CATransform3DTranslate(transform, yDelta, 0.0, 0.0)
                }
                
                if cellX > (collectionView.bounds.width - itemSize.width * 0.5) {
                    let yDelta = -getXDelta(x: collectionView.bounds.width-cellX)
                    transform = CATransform3DTranslate(transform, yDelta, 0.0, 0.0);
                }


                //transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0)
                attribute.alpha = sqrtDistributor(x: distanceFromCenter, threshold: period*0.5, xOrigin: period*0.6)
                attribute.zIndex = Int(zIndexValue * 1000)
                attribute.transform3D = transform
            }
            return attributes
        case .vertical:
            
            targetRect.origin = CGPoint(x: rect.origin.x, y: rect.origin.y-rect.height/2)

                        targetRect.size = CGSize(width: rect.width , height: rect.height * 2)
                        guard let collectionView = collectionView, let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
                        for attribute in attributes {
                            //cellCenterX
                            
                            let cellY = collectionView.convert(attribute.center, to: nil).y //- collectionView.frame.origin.y
                            
                            let difference = collectionView.center.y - cellY
                            
                            let zIndexValue = -pow(abs(difference)/collectionView.frame.size.height, 2.0) + 1.0
                            let scaleFactor = -pow((difference / 1.8)/collectionView.frame.size.height * 2.0, 2.0) + 1.0
                            
                            let numPeriods = floor(Double(cellY / periodH))
                            let adjustment = CGFloat(numPeriods) * periodH
                            let relativeDistanceFromCenter = collectionView.center.y - (cellY - adjustment)
                            let centerProximityMagnitude = sinDistributor(x: cellY, period: period, xOffset: collectionView.center.y)
                            
                            var transform = CATransform3DIdentity
                            let distanceFromCenter = fabs(collectionView.center.y - cellY)

//                            print(attribute.indexPath.item);
//                            print(cellY)

                            
                            if cellY <= (itemSize.height * 0.5 + collectionView.frame.origin.y) {
                                let yDelta = getYDelta(y: cellY - collectionView.frame.origin.y)
                                transform = CATransform3DTranslate(transform, 0.0, yDelta, 0.0)
//                                transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0)
                                //let scale = sqrtDistributor(x: distanceFromCenter, threshold: periodH*0.5, xOrigin: periodH*0.6) * 0.3 + 0.7
                                
                                let scale = (( 1 - yDelta/itemSize.height * 0.5)) * 0.3 + 0.7
                                transform = CATransform3DScale(transform, scale, scale, 1.0)
                                print(scale)
                                print(attribute.indexPath.item)

                            }

                            
                            if cellY > (collectionView.bounds.height - itemSize.height * 0.5 + collectionView.frame.origin.y) {
                                let yDelta = -getYDelta(y: collectionView.bounds.height-cellY+collectionView.frame.origin.y)
                                transform = CATransform3DTranslate(transform, 0.0, yDelta, 0.0);
//                                transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0)
                                let scale = sqrtDistributor(x: distanceFromCenter, threshold: periodH*0.5, xOrigin: periodH*0.6) * 0.3 + 0.7
                                transform = CATransform3DScale(transform, scale, scale, 1.0)
                                

                            }


            //                transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0)
                            attribute.alpha = sqrtDistributor(x: distanceFromCenter, threshold: periodH*0.5, xOrigin: periodH*0.6)
                            attribute.zIndex = Int(zIndexValue * 1000)
                            attribute.transform3D = transform
                        }
                        return attributes
            
            return nil
        }
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                           withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return CGPoint.zero}
        let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        switch scrollDirection {
        case .horizontal:
            let difference = collectionView.frame.size.width / 2 - sectionInset.left - itemSize.width/2
            let inset = collectionView.contentInset.left
            let row: CGFloat = ((latestOffset.x - inset + difference) / (itemSize.width + minimumLineSpacing)).rounded()
            let calculatedOffset = row * itemSize.width + row * minimumLineSpacing + inset
            let targetOffset = CGPoint(x: ((row == 0 && proposedContentOffset.x < (calculatedOffset - difference)) || ((Int(row) ==
                collectionView.numberOfItems(inSection: 0) - 1) && proposedContentOffset.x > (calculatedOffset - difference) )) ?
                    proposedContentOffset.x : calculatedOffset - difference, y: latestOffset.y)
            return targetOffset
        case .vertical:
            
            let difference = collectionView.frame.size.height / 2 - sectionInset.top - itemSize.height/2
            let inset = collectionView.contentInset.top
            let row: CGFloat = ((latestOffset.y - inset + difference) / (itemSize.height + minimumInteritemSpacing)).rounded()
            let calculatedOffset = row * itemSize.height + row * minimumInteritemSpacing + inset
//            let targetOffset = CGPoint(x: ((row == 0 && proposedContentOffset.y < (calculatedOffset - difference)) || ((Int(row) ==
//                collectionView.numberOfItems(inSection: 0) - 1) && proposedContentOffset.x > (calculatedOffset - difference) )) ?
//                    proposedContentOffset.y : calculatedOffset - difference, y: latestOffset.y)
            let targetOffset = CGPoint(x: ((row == 0 && proposedContentOffset.x < (calculatedOffset - difference)) || ((Int(row) ==
                     collectionView.numberOfItems(inSection: 0) - 1) && proposedContentOffset.x > (calculatedOffset - difference) )) ?
                         proposedContentOffset.x : calculatedOffset - difference, y: latestOffset.y)
            return targetOffset

            return CGPoint.zero
        }
    }
    
    /**
     Distribution function that start as a square root function and levels off when reaches y = 1.
     - parameter x: X parameter of the function. Current layout implementation uses center.x coordinate of collectionView cells.
     - parameter threshold: The x coordinate where function gets value 1.
     - parameter xOrigin: x coordinate of the function origin.
     */
    private func sqrtDistributor(x: CGFloat, threshold: CGFloat, xOrigin: CGFloat) -> CGFloat {
        var arg = (x - xOrigin)/(threshold - xOrigin)
        arg = arg <= 0 ? 0 : arg
        let y = sqrt(arg)
        return y > 1 ? 1 : y
    }
    
    /**
     - parameter x: X parameter of the function. Current layout implementation uses center.x coordinate of collectionView cells.
     - parameter period: The period of the function.
     - parameter xOffset: x coordinate where the function crosses 0 coordinate.
     */
    private func sinDistributor(x: CGFloat, period: CGFloat, xOffset: CGFloat) -> CGFloat {
        let halfPeriod = period / 2
        return sin(x/(halfPeriod / CGFloat.pi) - xOffset/(halfPeriod / CGFloat.pi))
    }
    
    private func getXDelta(x: CGFloat) -> CGFloat {
        return itemSize.width * 0.5 - x
    }

    private func getYDelta(y: CGFloat) -> CGFloat {
        return itemSize.height * 0.5 - y
    }

}

