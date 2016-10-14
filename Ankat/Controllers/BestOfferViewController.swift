//
//  BestOfferViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/24/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class BestOfferViewController: UIViewController {

    @IBOutlet var monsterAnimation: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        monsterAnimation.alpha = 0
        monsterAnimation.monsterType = MonsterTypes.monster2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animator?.bounces(monsterAnimation)
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
