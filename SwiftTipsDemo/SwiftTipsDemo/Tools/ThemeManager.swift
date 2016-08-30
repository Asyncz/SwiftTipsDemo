//
//  ThemeManager.swift
//  SwiftTipsDemo
//
//  Created by 张飞 on 16/8/15.
//  Copyright © 2016年 张飞. All rights reserved.
//

/// 模式、主题切换
import Foundation
import UIKit

//为了便于查看可以进一步处理,如这个例子,其实核心在extension里,这部分是可有可无的

//同时也可以定制化一些常用的控件,也能减少代码量 如:
//class lightLabel :UILabel{
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setTheme()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setTheme()
//    }
//    private func setTheme(){
//        themeBlock1 = { _ in
//            self.textColor = UIColor.lightGrayColor()
//        }
//        themeBlock2 = { _ in
//            self.textColor = UIColor.darkGrayColor()
//        }
//    }
//}

enum ThemeType{
    case Type1
    case Type2
}
class ThemeManager {
    static let shareManager = ThemeManager()
    var type:ThemeType = .Type2{
        didSet{
            let ud = NSUserDefaults.standardUserDefaults()
            switch type {
            case .Type1:
                UIView.appearance().setType(1)
                //注意: 导航栏的处理相对特殊
                UINavigationBar.appearance().barTintColor = UIColor.blueColor()
                ud.setInteger(1, forKey: "theme")
            default:
                UIView.appearance().setType(2)
                //注意: 导航栏的处理相对特殊
                UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
                ud.setInteger(2, forKey: "theme")
            }
            ud.synchronize()
        }
    }
    
    class func setType(type: ThemeType) {
        switch type {
        case .Type1:
            ThemeManager.shareManager.type = .Type1
        default:
            ThemeManager.shareManager.type = .Type2
        }
    }
}

/****************************************************************/
typealias ThemeBlock = @convention(block) (UIView) -> Void
extension UIView{
    
    private struct AssociatedKeys {
        static var themeBlock1 = "themeBlock1"
        static var themeBlock2 = "themeBlock2"
    }
    //自定义的UIApearance方法，调用方法为 UIView.appearance().setType(1) UIApearance的具体特性可以自己去尝试和查资料
    //通过type切换模式
    dynamic func setType(type: Int){
        switch type {
        case 1:
            if themeBlock1 != nil {
                themeBlock1!(self)
            }
        default:
            if themeBlock2 != nil {
                themeBlock2!(self)
            }
        }
    }
    var themeBlock1: ThemeBlock?{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.themeBlock1)
            return unsafeBitCast(value, ThemeBlock.self)
        }
        set {
            if let newValue = newValue {
                let value:AnyObject = unsafeBitCast(newValue, AnyObject.self)
                objc_setAssociatedObject( self, &AssociatedKeys.themeBlock1, value, .OBJC_ASSOCIATION_COPY )
            }
        }
    }
    var themeBlock2: ThemeBlock?{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.themeBlock2)
            return unsafeBitCast(value, ThemeBlock.self)
        }
        set {
            if let newValue = newValue {
                let value:AnyObject = unsafeBitCast(newValue, AnyObject.self)
                objc_setAssociatedObject( self, &AssociatedKeys.themeBlock2, value, .OBJC_ASSOCIATION_COPY )
            }
        }
    }
    
}