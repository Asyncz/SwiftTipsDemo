//
//  ThemeSettingViewController.swift
//  SwiftTipsDemo
//
//  Created by 张飞 on 16/8/30.
//  Copyright © 2016年 张飞. All rights reserved.
//

import UIKit

class ThemeSettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //这里特别注意,这样写tableView的颜色在点击选择之后是不会直接改变的,需要进入其它界面再打开这个界面才行,原因请搜索UIApearance进行了解
        //测试模式切换
        tableView.themeBlock1 = { _ in
            self.tableView.backgroundColor = UIColor.yellowColor()
        }
        tableView.themeBlock2 = { _ in
            self.tableView.backgroundColor = UIColor.whiteColor()
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
// MARK: - UITableViewDataSource UITableViewDelegate
extension ThemeSettingViewController:UITableViewDataSource ,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.row == 0 {
            cell.textLabel?.text = "模式一"
        }else if indexPath.row == 1{
            cell.textLabel?.text = "模式二"
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            ThemeManager.setType(.Type1)
            //为了实时效果
            tableView.backgroundColor = UIColor.yellowColor()
            //注意: 导航栏的处理相对特殊,可参照ThemeManager处理
            navigationController?.navigationBar.barTintColor = UIColor.blueColor()
        }else if indexPath.row == 1{
            ThemeManager.setType(.Type2)
            //为了实时效果
            tableView.backgroundColor = UIColor.whiteColor()
            //注意: 导航栏的处理相对特殊,可参照ThemeManager处理
            navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        }
        
        
        //注意:为了实现实时效果,可以刷新tableView,如果不是类似tableView这样的空间,想实现实时改变当前界面控件颜色的效果可以直接改颜色  如 view.backgroundColor = UIColor.whiteColor() 具体情况可以自己做实验
        tableView.reloadData()
        
        //第二种处理方式,选择之后,立即返回上个界面
//        navigationController?.popViewControllerAnimated(true)
        }
}