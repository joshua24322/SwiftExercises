//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/2/24.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController?
    //Called when the system needs the view controller to use for determining status bar style
    {
        return topViewController
        //The view controller at the top of the navigation stack.
    }
}
