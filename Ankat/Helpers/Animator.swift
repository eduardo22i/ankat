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
    case slow = 0.3
    case medium = 0.2
    case fast = 0.1
}

enum AnimationDirection : Int {
    case left = 1
    case top = 2
    case right = 3
    case bottom = 4
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
        
        
        let animator = UIDynamicAnimator(referenceView: self.referenceView!)
        self.animator = animator
        
    }
    
    
    func setDynamicReferenceView (_ referenceView : UIView ) {
        self.referenceView = referenceView
        
        
        //var animator = UIDynamicAnimator(referenceView: self.referenceView)
        //self.animator = animator
        animator = UIDynamicAnimator(referenceView: referenceView)
        print(animator)
    }
    
    func snapAnimate (_ object : AnyObject) {
        
        animator?.removeAllBehaviors()
        
        let view = object as! UIView
        
        let prev = view.center
        view.center = CGPoint(x: view.center.x, y: view.center.y - 200)
        let snapBehavior = UISnapBehavior(item: view, snapTo: prev)
        snapBehavior.damping = 0.3
        animator!.addBehavior(snapBehavior)
        
        self.snapBehavior = snapBehavior
        
    }
    
    func snapAnimate (_ object : AnyObject, toLocation : CGPoint) {

        animator?.removeAllBehaviors()
        
        let view = object as! UIView
        
        let prev = toLocation
        view.center = CGPoint(x: toLocation.x, y: toLocation.y - 200)
        let snapBehavior = UISnapBehavior(item: view, snapTo: prev)
        snapBehavior.damping = 0.3
        animator!.addBehavior(snapBehavior)
        
        self.snapBehavior = snapBehavior

    }
    
    func snapAnimateInPlace (_ object : AnyObject) {
        
        animator?.removeAllBehaviors()
        
        let view = object as! UIView
        
        let snapBehavior = UISnapBehavior(item: view, snapTo: view.center)
        snapBehavior.damping = 0.3
        animator!.addBehavior(snapBehavior)
        
        self.snapBehavior = snapBehavior
        
    }
    
    //MARK: Loops
    
    func loop (_ object : AnyObject) {
        
        let view = object as! UIView
        
        UIView.animateKeyframes(withDuration: 2, delay: 0.0, options: UIViewKeyframeAnimationOptions.repeat , animations: { () -> Void in
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: { () -> Void in
                view.alpha = 1.0
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { () -> Void in
                view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                view.alpha = 0.0
            })
            
        }) { (ended : Bool) -> Void in
            
            
        }
    }
    
    //MARK: Bounces
    
    
    func bounces (_ object : AnyObject) {
        
        bounces(object, delay: 0.0)
        
    }
    
    
    func bounces (_ object : AnyObject, delay : Double) {
        
        let view = object as! UIView
        
        let originalPos = CGPoint(x: view.center.x, y: view.center.y )
        
        view.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        
        let animationTime = 0.1
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: animationTime * 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            view.center = CGPoint(x: view.center.x, y: view.center.y - 110)
            view.alpha = 1
            view.transform = CGAffineTransform.identity
            
            }) { (Bool) -> Void in
                
                
                UIView.animate(withDuration: animationTime, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    view.center = CGPoint(x: view.center.x, y: view.center.y + 20)
                    
                    }) { (Bool) -> Void in
                        
                        UIView.animate(withDuration: animationTime, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                            view.center = CGPoint(x: view.center.x, y: view.center.y - 10 )
                            
                            }) { (Bool) -> Void in
                                
                                UIView.animate(withDuration: animationTime, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                                    view.center = originalPos
                                    }) { (Bool) -> Void in
                                        view.center = originalPos
                                }
                        }
                }
        }
        
    }
    
    
    func bouncesSmall (_ object : AnyObject, delay : Double) {
        
        let view = object as! UIView
        
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIViewKeyframeAnimationOptions.autoreverse , animations: { () -> Void in
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: { () -> Void in
                view.center = CGPoint(x: view.center.x, y: view.center.y + 1)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { () -> Void in
                view.center = CGPoint(x: view.center.x, y: view.center.y - 2)
            })
            
            }) { (ended : Bool) -> Void in
                
                
        }
        
    }
    
    
    //MARK: Fades IN
    
    func fadeIn (_ object : AnyObject, direction: AnimationDirection) {
        fadeIn(object, delay: 0.0, direction : direction, velocity: AnimationVelocity.medium)
    }
    
    func fadeIn (_ object : AnyObject, delay : Double, direction: AnimationDirection, velocity: AnimationVelocity, alpha : CGFloat, uniformScale : CGFloat) {
        
        let view = object as! UIView
        
        view.alpha = alpha
        view.transform = CGAffineTransform(scaleX: uniformScale, y: uniformScale)

        fadeIn(object, delay: 0.0, direction : direction, velocity: velocity)
    }
    
    func fadeIn (_ object : AnyObject, delay : Double, direction: AnimationDirection, velocity : AnimationVelocity) {
        
        let view = object as! UIView
        let objectCenter = view.center
        
        let offset = 100.0
        var startLocation = CGPoint(x: objectCenter.x, y: objectCenter.y)
        
        switch (direction) {
        case .left:
            startLocation = CGPoint(x: startLocation.x + CGFloat(offset), y: startLocation.y )
            break;
        case .top:
            startLocation = CGPoint(x: startLocation.x, y: startLocation.y + CGFloat(offset))
            break;
        case .right:
            startLocation = CGPoint(x: startLocation.x - CGFloat(offset), y: startLocation.y )
            break;
        case .bottom:
            startLocation = CGPoint(x: startLocation.x, y: startLocation.y - CGFloat(offset))
            break;
        }
        
        view.center = startLocation
        
        UIView.animate(withDuration: velocity.rawValue , delay: delay, options: UIViewAnimationOptions.curveEaseOut,
            animations: { () -> Void in
                
                view.alpha = 1
                view.center = objectCenter
                
                view.transform = CGAffineTransform.identity
                
            }, completion: nil)
        
        
    }
    
    //MARK: Fades Out
    
    func fadeOut (_ object : AnyObject, direction: AnimationDirection) {
        fadeOut(object, delay: 0.0, direction : direction, velocity: AnimationVelocity.medium)
    }
    
    func fadeOut (_ object : AnyObject, delay : Double, direction: AnimationDirection, velocity : AnimationVelocity) {
        
        let view = object as! UIView
        let objectCenter = view.center
        
        let offset = -100.0
        var startLocation = CGPoint(x: objectCenter.x, y: objectCenter.y)
        
        switch (direction) {
        case .left:
            startLocation = CGPoint(x: startLocation.x + CGFloat(offset), y: startLocation.y )
            break;
        case .top:
            startLocation = CGPoint(x: startLocation.x, y: startLocation.y + CGFloat(offset))
            break;
        case .right:
            startLocation = CGPoint(x: startLocation.x - CGFloat(offset), y: startLocation.y )
            break;
        case .bottom:
            startLocation = CGPoint(x: startLocation.x, y: startLocation.y - CGFloat(offset))
            break;
        }
        
        view.center = startLocation
        
        UIView.animate(withDuration: velocity.rawValue , delay: delay, options: UIViewAnimationOptions.curveEaseIn,
            animations: { () -> Void in
                
                view.alpha = 0
                view.center = objectCenter
                //view.transform = CGAffineTransformMakeScale(0, 0)
                
            }, completion: nil)
        
        
    }
    
    func fadeDown (_ object : AnyObject) {
        
        fadeDown(object, delay: 0.0)
        
    }
    
    func fadeDown (_ object : AnyObject, delay : Double) {
        
        fadeDown(object, delay: 0.0) { (ended: Bool, error : NSError?) -> Void in
            
        }
        
    }
    
    func fadeDown (_ object : AnyObject, delay : Double, blockAn : @escaping AnimationEnded) {
        
        let view = object as! UIView
        view.alpha = 1
        
        UIView.animate(withDuration: 0.1, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            view.center = CGPoint(x: view.center.x, y: view.center.y + 100)
            view.alpha = 0
        }) { (ended: Bool) -> Void in
            blockAn(true, nil)
        }
    }
    
    
    
    func fadeLeft (_ object : AnyObject) {
        
        fadeLeft(object, delay: 0.0)
        
    }
    
    func fadeLeft (_ object : AnyObject, delay : Double) {
        
        fadeLeft(object, delay: 0.0) { (ended: Bool, error : NSError?) -> Void in
            
        }
        
    }
    

    func fadeLeft (_ object : AnyObject, delay : Double, blockAn : @escaping AnimationEnded) {
        
        let view = object as! UIView
        view.alpha = 1
        
        UIView.animate(withDuration: 0.1, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            view.center = CGPoint(x: view.center.x - 100, y: view.center.y)
            view.alpha = 0
            }) { (ended: Bool) -> Void in
                blockAn(true, nil)
        }
    }

    
    
}
