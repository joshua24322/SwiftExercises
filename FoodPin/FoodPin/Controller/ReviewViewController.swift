//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/3/5.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]! // rating icon
    @IBOutlet weak var closeButton: UIButton! //            17.12 Solution to Exercise #1
    
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: restaurant.image)
        
        // MARK: - 實作模糊較果
        let blurEffect = UIBlurEffect(style: .regular) //應用模糊較果，<#T##UIBlurEffectStyle#> is enum
        let blurEfectView = UIVisualEffectView(effect: blurEffect) // UIVisualEffectView　為視圖增加視覺效果
        blurEfectView.frame = view.bounds
        backgroundImageView.addSubview(blurEfectView)
        
        // MARK: - 實作仿射變形 (Affine Transformation)
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0) //  實作「affine transformation」 ，將rating視圖移至畫面右側600點的漸行變化
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0) //加上縮放(Scale)的放大變形，讓視圖變為5倍大
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform) //呼叫concatenating函數，將scaleUpTransform與moveRightTransform組合在一起 (combining two existing affine transforms)
        
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform // 使rateButtons按鈕移動至右側畫面之外
            rateButton.alpha = 0 // 隱藏按鈕狀態
        }
        
        //            17.12 Solution to Exercise #1
        let moveTopTransform = CGAffineTransform.init(translationX: 0, y: -600) // 將close按鈕上移到畫面上方600點的漸行變化
        closeButton.transform = moveTopTransform
    }
    
    override func viewWillAppear(_ animated: Bool) {
//         呼叫 UIView.animate(withDuration: <#T##TimeInterval#>, animations: <#T##() -> Void#>) 方法，來讓alpha值做變化
//         在閉包內只要指定終止狀態(alpha = 1.0)，API會自動計算動畫
//         withDuration參數是指的動畫時間，此處動畫會在2秒內完成
        
//        MARK: - 淡入動畫
//        UIView.animate(withDuration: 2.0) {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[4].alpha = 1.0
//        }
     
//        延遲淡入動畫 & 滑入動畫
//        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[0].transform = .identity // 恆等變形，重設按鈕至原來的位置
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//            self.rateButtons[4].alpha = 1.0
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
        
//         彈簧動畫
//        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
//            for rateButtons in self.rateButtons {
//                rateButtons.alpha = 1.0
//                rateButtons.transform = .identity
//            }
//        }, completion: nil)
        
        
        // MARK: - 延遲淡入動畫 & 滑入動畫
        //            17.12 Solution to Exercise #2
        for index in 0...rateButtons.count - 1 {
            UIView.animate(withDuration: 0.4, delay: 0.1 + 0.05 * Double(index), options: [], animations: {
                self.rateButtons[index].alpha = 1.0
                self.rateButtons[index].transform = .identity // 恆等變形，重設按鈕至原來的位置
            }, completion: nil)
        }
        // MARK: - 彈簧動畫
        //            17.12 Solution to Exercise #1
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
