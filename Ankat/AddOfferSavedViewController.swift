//
//  AddOfferSavedViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/15/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class AddOfferSavedViewController: UIViewController {

    var recommendation : Offer!
    
    @IBOutlet var firstOfferView: UIView!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var decoration1: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //animator = Animator(referenceView: self.view)
        
        
        decoration1.monsterType = MonsterTypes.monster2
        decoration1.alpha = 0
        
        if let recommendation = recommendation {
            self.title = recommendation.name ?? "Offer Saved"
        }
        self.navigationItem.hidesBackButton = true
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

    @IBAction func okAction(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
