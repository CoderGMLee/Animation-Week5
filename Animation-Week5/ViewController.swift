//
//  ViewController.swift
//  Animation-Week5
//
//  Created by GM on 16/8/22.
//  Copyright © 2016年 LGM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var animationView : AniamtionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        animationView = AniamtionView(frame: CGRectMake(100, 100, 100, 100))
        self.view.addSubview(animationView!)


    }

    @IBAction func animationAction(sender: AnyObject) {
        animationView?.startAniamtion()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

