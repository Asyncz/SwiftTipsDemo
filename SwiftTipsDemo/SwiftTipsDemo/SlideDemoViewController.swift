//
//  SlideDemoViewController.swift
//  SwiftTipsDemo
//
//  Created by 张飞 on 16/8/10.
//  Copyright © 2016年 张飞. All rights reserved.
//

import UIKit

class SlideDemoViewController: UIViewController {

    @IBOutlet weak var URLsSlide: SlideImages!      //url
    @IBOutlet weak var imagesSlide: SlideImages!    //本地图片
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        URLsSlide.interval = 1
        URLsSlide.setURLsWithArr(["http://www.szgushang.com/images/slider/bg1.jpg","http://www.szgushang.com/images/slider/bg2.jpg","http://www.szgushang.com/images/slider/bg3.jpg"]) { (index) in
            print("点击了第\(index)张图片")
        }
        
        imagesSlide.interval = 1.3
        imagesSlide.setImagesWithArr([UIImage(named: "image1.jpg")!,UIImage(named: "image2.jpg")!,UIImage(named: "image3.jpg")!,UIImage(named: "image4.jpg")!]) { (index) in
            print("点击了第\(index)张图片")
        }
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
