//
//  CountDownDemoViewController.swift
//  SwiftTipsDemo
//
//  Created by 张飞 on 16/8/10.
//  Copyright © 2016年 张飞. All rights reserved.
//

import UIKit

class CountDownDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func noAnimationAction(sender: CountDownBtn) {
        sender.startCountDown()
    }
    @IBAction func rotateBtnAction(sender: CountDownBtn) {
        sender.animaType = .Rotate
        sender.startCountDown()
    }
    @IBAction func scaleBtnAction(sender: CountDownBtn) {
        sender.animaType = .Scale
        sender.startCountDown()
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
