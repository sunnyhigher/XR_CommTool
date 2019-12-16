//
//  ViewController.swift
//  XR_CommonTool
//
//  Created by Mr.Xr on 12/04/2019.
//  Copyright (c) 2019 Mr.Xr. All rights reserved.
//

import UIKit
import XR_CommonTool


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _ = PurchaseTool()
        
        let list = [1,2,3,4,5]
        _ = list[safe: 10]
        _ = list.indexes(of: 4)
        
        
        XRReachabilityManager.networkChange { [weak self] (result) in
            if result {
                
            } else {
                
            }
        }
        
        XXLog(statusBarHeight)
        
        XXLog(navigationHeight)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

