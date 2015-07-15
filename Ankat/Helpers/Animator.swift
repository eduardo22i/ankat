//
//  Animator.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import QuartzCore

typealias AnimationEnded = (Bool, NSError?) -> Void

enum AnimationVelocity : Double {
    case Slow = 0.3
    case Medium = 0.2
    case Fast = 0.1
}

enum AnimationDirection : Int {
    case Left = 1
    case Top = 2
    case Right = 3
    case Bottom = 4
}

class Animator: NSObject {
   
    var referenceView : UIView? = nil
    var animator : UIDynamicAnimator? = nil
    var snapBehavior : UISnapBehavior? = nil
    
    
    override init() {
        animator = UIDynamicAnimator()
    }
    
    init( referenceView : UIView) {
        
        self.referenceView = referenceView
        
        
        var animator = UIDynamicAnimator(referenceView: self.referenceView!)
        self.animator = animator
        
    }
    
    
    func setDynamicReferenceView (referenceView : UIView ) {
        self.referenceView = referenceView
        
        
        //var animator = UIDynamicAnimator(referenceView: self.referenceView)
        //self.animator = animator
        animator = UIDynamicAnimator(referenceView: referenceView)
        println(animator)
    }
    
    func snapAnimate (object : AnyObject) {
        
        animator?.removeAllBehaviors()
        
        let view = object as! UIView
        
        let prev = view.center
        view.center = CGPointMake(view.center.x, view.center.y - 200)
        var snapBehavior = UISnapBehavior(item: view, snapToPoint: prev)
        snapBehavior.damping = 0.3
        animator!.addBehavior(snapBehavior)
        
        self.snapBehavior = snapBehavior
        
    }
    
    func snapAnimate (object : AnyObject, toLocation : CGPoint) {

        animator?.removeAllBehaviors()
        
        let view = object as! UIView
        
        let prev = toLocation
        view.center = CGPointMake(toLocation.x, toLocation.y - 200)
        var snapBehavior = UISnapBehavior(item: view, snapToPoint: prev)
        snapBehavior.damping = 0.3
        animator!.addBehavior(snapBehavior)
        
        self.snapBehavior = snapBehavior

    }
    
    func snapAnimateInPlace (object : AnyObject) {
        
        animator?.removeAllBehaviors()
        
        let view = object as! UIView
        
        var snapBehavior = UISnapBehavior(item: view, snapToPoint: view.center)
        snapBehavior.damping = 0.3
        animator!.addBehavior(snapBehavior)
        
        self.snapBehavior = snapBehavior
        
    }
    
    //MARK: Bounces
    
    
    func bounces (object : AnyObject) {
        
        bounces(object, delay: 0.0)
        
    }
    
    
    func bounces (object : AnyObject, delay : Double) {
        
        let view = object as! UIView
        
        let originalPos = CGPointMake(view.center.x, view.center.y )
        
        view.center = CGPointMake(view.center.x, view.center.y + 100)
        
        var animationTime = 0.1
        view.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(animationTime * 2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            view.center = CGPointMake(view.center.x, view.center.y - 110)
            view.alpha = 1
            view.transform = CGAffineTransformIdentity
            
            }) { (Bool) -> Void in
                
                
                UIView.animateWithDuration(animationTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    view.center = CGPointMake(view.center.x, view.center.y + 20)
                    
                    }) { (Bool) -> Void in
                        
                        UIView.animateWithDuration(animationTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            view.center = CGPointMake(view.center.x, view.center.y - 10 )
                            
                            }) { (Bool) -> Void in
                                
                                UIView.animateWithDuration(animationTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    view.center = originalPos
                                    }) { (Bool) -> Void in
                                        view.center = originalPos
                                }
                        }
                }
        }
        
    }
    
    
    func bouncesSmall (object : AnyObject, delay : Double) {
        
        let view = object as! UIView
        
        let originalPos = CGPointMake(view.center.x, view.center.y )
        
        view.center = CGPointMake(view.center.x, view.center.y + 5)
        
        UIView.animateWithDuration(0.1, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            view.center = CGPointMake(view.center.x, view.center.y - 3)
            view.alpha = 1
            
            }) { (Bool) -> Void in
                
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    view.center = CGPointMake(view.center.x, view.center.y + 2)
                    
                    }) { (Bool) -> Void in
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            view.center = CGPointMake(view.center.x, view.center.y - 1 )
                            
                            }) { (Bool) -> Void in
                                
                                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                                    view.center = originalPos
                                    }) { (Bool) -> Void in
                                        view.center = originalPos
                                }
                        }
                }
        }
    }
    
    
    //MARK: Fades IN
    
    func fadeIn (object : AnyObject, direction: AnimationDirection) {
        fadeIn(object, delay: 0.0, direction : direction, velocity: AnimationVelocity.Medium)
    }
    
    func fadeIn (object : AnyObject, delay : Double, direction: AnimationDirection, velocity: AnimationVelocity, alpha : CGFloat, uniformScale : CGFloat) {
        
        let view = object as! UIView
        
        view.alpha = alpha
        view.transform = CGAffineTransformMakeScale(uniformScale, uniformScale)

        fadeIn(object, delay: 0.0, direction : direction, velocity: velocity)
    }
    
    func fadeIn (object : AnyObject, delay : Double, direction: AnimationDirection, velocity : AnimationVelocity) {
        
        let view = object as! UIView
        let objectCenter = view.center
        
        let offset = 100.0
        var startLocation = CGPointMake(objectCenter.x, objectCenter.y)
        
        switch (direction) {
        case .Left:
            startLocation = CGPointMake(startLocation.x + CGFloat(offset), startLocation.y )
            break;
        case .Top:
            startLocation = CGPointMake(startLocation.x, startLocation.y + CGFloat(offset))
            break;
        case .Right:
            startLocation = CGPointMake(startLocation.x - CGFloat(offset), startLocation.y )
            break;
        case .Bottom:
            startLocation = CGPointMake(startLocation.x, startLocation.y - CGFloat(offset))
            break;
        default:
            break;
        }
        
        view.center = startLocation
        
        UIView.animateWithDuration(velocity.rawValue , delay: delay, options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                
                view.alpha = 1
                view.center = objectCenter
                
                view.transform = CGAffineTransformIdentity
                
            }, completion: nil)
        
        
    }
    
    //MARK: Fades Out
    
    func fadeOut (object : AnyObject, direction: AnimationDirection) {
        fadeOut(object, delay: 0.0, direction : direction, velocity: AnimationVelocity.Medium)
    }
    
    func fadeOut (object : AnyObject, delay : Double, direction: AnimationDirection, velocity : AnimationVelocity) {
        
        let view = object as! UIView
        let objectCenter = view.center
        
        let offset = -100.0
        var startLocation = CGPointMake(objectCenter.x, objectCenter.y)
        
        switch (direction) {
        case .Left:
            startLocation = CGPointMake(startLocation.x + CGFloat(offset), startLocation.y )
            break;
        case .Top:
            startLocation = CGPointMake(startLocation.x, startLocation.y + CGFloat(offset))
            break;
        case .Right:
            startLocation = CGPointMake(startLocation.x - CGFloat(offset), startLocation.y )
            break;
        case .Bottom:
            startLocation = CGPointMake(startLocation.x, startLocation.y - CGFloat(offset))
            break;
        default:
            break;
        }
        
        view.center = startLocation
        
        UIView.animateWithDuration(velocity.rawValue , delay: delay, options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                
                view.alpha = 0
                view.center = objectCenter
                //view.transform = CGAffineTransformMakeScale(0, 0)
                
            }, completion: nil)
        
        
    }
    
    func fadeDown (object : AnyObject) {
        
        fadeDown(object, delay: 0.0)
        
    }
    
    func fadeDown (object : AnyObject, delay : Double) {
        
        fadeDown(object, delay: 0.0) { (ended: Bool, error : NSError?) -> Void in
            
        }
        
    }
    
    func fadeDown (object : AnyObject, delay : Double, blockAn : AnimationEnded) {
        
        let view = object as! UIView
        view.alpha = 1
        
        UIView.animateWithDuration(0.1, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            view.center = CGPointMake(view.center.x, view.center.y + 100)
            view.alpha = 0
        }) { (ended: Bool) -> Void in
            blockAn(true, nil)
        }
    }
    
    
    
    func fadeLeft (object : AnyObject) {
        
        fadeLeft(object, delay: 0.0)
        
    }
    
    func fadeLeft (object : AnyObject, delay : Double) {
        
        fadeLeft(object, delay: 0.0) { (ended: Bool, error : NSError?) -> Void in
            
        }
        
    }
    

    func fadeLeft (object : AnyObject, delay : Double, blockAn : AnimationEnded) {
        
        let view = object as! UIView
        view.alpha = 1
        
        UIView.animateWithDuration(0.1, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            view.center = CGPointMake(view.center.x - 100, view.center.y)
            view.alpha = 0
            }) { (ended: Bool) -> Void in
                blockAn(true, nil)
        }
    }

    
    
}
