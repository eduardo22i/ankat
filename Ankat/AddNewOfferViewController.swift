//
//  AddNewOfferViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class AddNewOfferViewController: UIViewController {
    
    
    @IBOutlet var firstOfferView: UIView!
    @IBOutlet var createNewOfferButton: UIButton!
    @IBOutlet var firstOfferLabel: UILabel!
    @IBOutlet var decoration1: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //animator = Animator(referenceView: self.view)
        
        createNewOfferButton.roundCorners()
        
        decoration1.monsterType = MonsterTypes.monster2
        decoration1.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        animator?.fadeIn(decoration1, delay: 0.0, direction: AnimationDirection.top, velocity: AnimationVelocity.medium)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animator?.fadeOut(decoration1, delay: 0.0, direction: AnimationDirection.left, velocity: AnimationVelocity.medium)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
