//
//  FrameAnimations.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/7/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

enum MonsterTypes : Int {
    case monster1 = 1
    case monster2 = 2
    case monster3 = 3
    case monster4 = 4
    case monster5 = 5
}

class FrameAnimations: UIImageView {
    
    
    var monsterType: MonsterTypes = .monster1  {didSet {
            originalCenter = self.center
            animate()
        }
    }
    
    
    var originalCenter = CGPoint(x: 0, y: 0)

    
    func animate() {
        
        switch (monsterType) {
        case .monster1 :
                animationImages = [ UIImage(named: "Monster 1 A")!, UIImage(named: "Monster 1 B")!]
            break;
        case .monster2 :
            animationImages = [ UIImage(named: "Monster 2 A")!,  UIImage(named: "Monster 2 B")!]
            break;
        case .monster3 :
            animationImages = [ UIImage(named: "Monster 3 A")!, UIImage(named: "Monster 3 B")!]
            break;
        case .monster4 :
            animationImages = [ UIImage(named: "Monster 4 A")!,  UIImage(named: "Monster 4 B")!]
            break;
        case .monster5 :
            animationImages = [ UIImage(named: "Monster 5 A")!,  UIImage(named: "Monster 5 B")!]
            break;
        }
        
        animationRepeatCount = 0
        animationDuration = 0.3
        startAnimating()
        
    }
    
    //MARK: Scrolls
    
    var lastOffset : CGPoint = CGPoint(x: 0, y: 0)
    var lastOffsetCapture : TimeInterval = 0
    var isScrollingFast : Bool = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset;
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        let timeDiff = currentTime - lastOffsetCapture;
        if(timeDiff > 0.1) {
            let distance = currentOffset.y - lastOffset.y;
            //The multiply by 10, / 1000 isn't really necessary.......
            let scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
            
            let scrollSpeed = fabs(scrollSpeedNotAbs);
            
            self.alpha = (currentOffset.y < 0) ? fabs(currentOffset.y/100) - 0.3 : 0
            
            if distance < 0 {
                self.center = CGPoint(x: self.center.x, y: self.center.y >=  self.originalCenter.y ? self.center.y + (currentOffset.y/100) * 2 : self.center.y)
            } else {
                self.center = CGPoint(x: self.center.x, y: self.center.y - (currentOffset.y/100) * 2 )
            }
            
            if (scrollSpeed > 0.5) {
                isScrollingFast = true;
            } else {
                isScrollingFast = false;
            }
            
            lastOffset = currentOffset;
            lastOffsetCapture = currentTime;
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.center = CGPoint(x: self.originalCenter.x, y: self.originalCenter.y + 40)
    }

}
