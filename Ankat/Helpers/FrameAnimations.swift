//
//  FrameAnimations.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/7/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

enum MonsterTypes : Int {
    case Monster1 = 1
    case Monster2 = 2
    case Monster3 = 3
    case Monster4 = 4
}

class FrameAnimations: UIImageView {
    
    
    var monsterType: MonsterTypes = .Monster1  {didSet {
            originalCenter = self.center
            animate()
        }
    }
    
    
    var originalCenter = CGPointMake(0, 0)

    
    func animate() {
        
        switch (monsterType) {
        case .Monster1 :
                animationImages = [ UIImage(named: "Monster 1 A")!, UIImage(named: "Monster 1 B")!]
            break;
        case .Monster2 :
            animationImages = [ UIImage(named: "Monster 2 A")!,  UIImage(named: "Monster 2 B")!]
            break;
        case .Monster3 :
            animationImages = [ UIImage(named: "Monster 3 A")!, UIImage(named: "Monster 3 B")!]
            break;
        case .Monster4 :
            animationImages = [ UIImage(named: "Monster 4 A")!,  UIImage(named: "Monster 4 B")!]
            break;
        default:
            animationImages = [ UIImage(named: "Monster 1 A")!, UIImage(named: "Monster 1 B")!]
            break;
        }
        
        animationRepeatCount = 0
        animationDuration = 0.3
        startAnimating()
        
    }
    
    //MARK: Scrolls
    
    var lastOffset : CGPoint = CGPointMake(0, 0)
    var lastOffsetCapture : NSTimeInterval = 0
    var isScrollingFast : Bool = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("Scrolling")
        //profileImageView.center = CGPointMake(profileImageView.center.x, profileImageView.center.y - 10)
        
        let currentOffset = scrollView.contentOffset;
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        let timeDiff = currentTime - lastOffsetCapture;
        if(timeDiff > 0.1) {
            let distance = currentOffset.y - lastOffset.y;
            //The multiply by 10, / 1000 isn't really necessary.......
            let scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
            
            let scrollSpeed = fabs(scrollSpeedNotAbs);
            
            self.alpha = (currentOffset.y < 0) ? fabs(currentOffset.y/100) - 0.3 : 0
            
            //
            if distance < 0 {
                self.center = CGPointMake(self.center.x, self.center.y >=  self.originalCenter.y ? self.center.y + (currentOffset.y/100) * 2 : self.center.y)
            } else {
                self.center = CGPointMake(self.center.x, self.center.y - (currentOffset.y/100) * 2 )
            }
            println(distance)
            
            if (scrollSpeed > 0.5) {
                isScrollingFast = true;
                //NSLog("Fast");
            } else {
                isScrollingFast = false;
                //NSLog("Slow");
            }
            
            lastOffset = currentOffset;
            lastOffsetCapture = currentTime;
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.center = CGPointMake(self.originalCenter.x, self.originalCenter.y + 40)
    }

}
