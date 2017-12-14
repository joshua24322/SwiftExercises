//
//  ViewController.swift
//  FortuneTeller
//
//  Created by 張書彬 on 2017/12/14.
//  Copyright © 2017年 Joshua Chang. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var yourFortune: UIImageView!
    
    
    @IBAction func tellMeSomethinf(_ sender: UIButton) {
        showAnswer()
    }
    
//    once system happen some events, system shall call this motionEnded method
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
//        what event occur == when got shook
        if event?.subtype == .motionShake {
            showAnswer()
        }
    }
    
    func showAnswer() {
        
        if yourFortune.isHidden == true {
//            show me the answer
            
            //        1. make a random number 1 ~ 6
            let answer = GKRandomSource.sharedRandom().nextInt(upperBound: 6) + 1
            //        2. change image
            yourFortune.image = UIImage(named: "\(answer)")
            //          display image
            yourFortune.isHidden = false
            //        3. sound
            AudioServicesPlaySystemSound(1000)
        } else {
//            hide image
            yourFortune.isHidden = true
        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

