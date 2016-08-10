//
//  Confi.swift
//  SwiftTipsDemo
//
//  Created by 张飞 on 16/8/10.
//  Copyright © 2016年 张飞. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView{
    // Kingfisher的覆盖  好处：1.不用所有界面都去导入 2.如果KingfisherAPI更新或者更换图片加载库可以更方便一些，保持方法名和第一个参数不变，修改一下就能达到目的，比如修改为使用SDWebImage
    public func setMyImageWithURL(URL: NSURL?,
                                   placeholderImage: Image? = nil,
                                   optionsInfo: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: CompletionHandler? = nil) -> RetrieveImageTask{
        return kf_setImageWithURL(URL,
                                  placeholderImage: placeholderImage,
                                  optionsInfo: optionsInfo,
                                  progressBlock: progressBlock,
                                  completionHandler: completionHandler)
    }
}