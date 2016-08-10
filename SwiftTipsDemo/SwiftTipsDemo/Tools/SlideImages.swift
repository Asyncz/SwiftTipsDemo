//
//  SlideImages.swift
//  PointsMall
//
//  Created by 张飞 on 16/6/19.
//  Copyright © 2016年 张飞. All rights reserved.
//

/// 轮播图

import UIKit


class SlideImages: UIView ,UIScrollViewDelegate{
    private enum ImageType{
        case Image     //本地图片
        case URL       //URL
    }
    
    private var scrollView:UIScrollView?
    private var index:Int = 0{
        didSet{
            switch type {
            case .Image:
                changeLeftIndeAndRightIndeWith(imageArr)
            default:
                changeLeftIndeAndRightIndeWith(urlArr)
            }
        }
    }
    
    private var leftImg = UIImageView()
    private var centerImg = UIImageView()
    private var rightImg = UIImageView()
    private var pageControl = UIPageControl()
    private var timer:NSTimer?
    private var leftIndex:Int = 0
    private var rightIndex:Int = 0
    private var type:ImageType = .Image

    /// 间隔时间
    var interval:Double = 4
    /// 点击回调
    var clickBlock :(Int)->Void = {index in}
    /// url图片数组
    var urlArr = [String](){
        didSet{
            type = .URL
            setSlideImages()
        }
    }
    /// 本地图片数组
    var imageArr = [UIImage](){
        didSet{
            type = .Image
            setSlideImages()
        }
    }
    //需要的时候刷新内容大小，其实最好的方法是设置所有内容的约束，但是代码写约束太麻烦了，所以就用了这样的方式
    override func layoutSubviews() {
        super.layoutSubviews()
        setSlideImages()
    }
    
    //设置图片URL
    func setURLsWithArr(arr:[String],imageClickBlock:(Int) -> Void ) {
        urlArr = arr
        clickBlock = imageClickBlock
    }
    //设置图片
    func setImagesWithArr(arr:[UIImage],imageClickBlock:(Int) -> Void ) {
        imageArr = arr
        clickBlock = imageClickBlock
    }
    
    private func setSlideImages(){
        //关闭定时器并清除所有内容
        closeTimer()
        for view in subviews {
            view.removeFromSuperview()
        }
        
        if urlArr.count == 0 && imageArr.count == 0{
            return
        }
        
        if urlArr.count == 1 || imageArr.count == 1{//只有一张图片不用滚动
            centerImg = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            centerImg.userInteractionEnabled = true
            addTapGesWithImage(centerImg)
            
            switch type {
            case .Image:
                centerImg.image = imageArr[0]
            default:
                centerImg.setMyImageWithURL(NSURL(string: urlArr[0]), placeholderImage: UIImage(named: "place"))
            }
            
            addSubview(centerImg)
        }else{//多张图片需要滚动
            //scrollview
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            addSubview(scrollView!)
            scrollView?.delegate = self
            scrollView?.pagingEnabled = true
            scrollView?.contentSize = CGSize(width: frame.size.width*3, height: frame.size.height)
            scrollView?.showsHorizontalScrollIndicator = false
            
            //images
            leftImg.contentMode = .ScaleAspectFill
            centerImg.contentMode = .ScaleAspectFill
            rightImg.contentMode = .ScaleAspectFill
            leftImg.layer.masksToBounds = true
            centerImg.layer.masksToBounds = true
            rightImg.layer.masksToBounds = true
            
            scrollView!.addSubview(leftImg)
            scrollView!.addSubview(rightImg)
            scrollView!.addSubview(centerImg)
            
            leftImg.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            centerImg.frame = CGRect(x: frame.size.width, y: 0, width: frame.size.width, height: frame.size.height)
            rightImg.frame = CGRect(x: frame.size.width*2, y: 0, width: frame.size.width, height: frame.size.height)
            
            addTapGesWithImage(leftImg)
            addTapGesWithImage(centerImg)
            addTapGesWithImage(rightImg)
            
            //pagecontrol
            pageControl.center = CGPoint(x: frame.size.width/2, y: frame.size.height-15)
            addSubview(pageControl)
            pageControl.currentPage = 0
            pageControl.numberOfPages = urlArr.count
            switch type {
            case .Image:
                pageControl.numberOfPages = imageArr.count
            default:
                pageControl.numberOfPages = urlArr.count
            }
            pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
            pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
            
            //初始化数据
            index = 0
            setImages()

            //timer
            openTimer()
        }
    }
    //通过index确定leftIndex和rightIndex的值
    private func changeLeftIndeAndRightIndeWith(arr:[AnyObject]){
        if arr.count == 0 {
            return
        }
        leftIndex = index - 1
        if leftIndex<0 {
            leftIndex = (arr.count)-1
        }
        rightIndex = index + 1
        if rightIndex>(arr.count)-1 {
            rightIndex = 0
        }
        centerImg.tag = index
        leftImg.tag = leftIndex
        rightImg.tag = rightIndex
    }
    //给图片添加点击手势
    private func addTapGesWithImage(image:UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        image.userInteractionEnabled = true
        image.contentMode = .ScaleAspectFill
        image.clipsToBounds = true
        image.addGestureRecognizer(tap)
    }
    
    //将centerImg移动到显示位置 改变三个imageView显示的图片
    private func setImages(){
        scrollView?.setContentOffset(CGPoint(x: frame.size.width,y:0), animated: false)
        pageControl.currentPage = index
        
        switch type {
        case .Image:
            leftImg.image = imageArr[leftIndex]
            centerImg.image = imageArr[index]
            rightImg.image = imageArr[rightIndex]
        default:
            let leftUrl = urlArr[leftIndex]
            let rightUrl = urlArr[rightIndex]
            let centerUrl = urlArr[index]
            
            leftImg.setMyImageWithURL(NSURL(string: leftUrl), placeholderImage: UIImage(named: "place"))
            rightImg.setMyImageWithURL(NSURL(string: rightUrl), placeholderImage: UIImage(named: "place"))
            centerImg.setMyImageWithURL(NSURL(string:centerUrl), placeholderImage: UIImage(named: "place"))
        }
    }
    
    //点击图片，调用block
    @objc private func tap(ges:UITapGestureRecognizer) {
        clickBlock((ges.view?.tag)!)
    }
    //自动滚动
    @objc private func startScroll() {
        scrollView?.setContentOffset(CGPoint(x: frame.size.width*2,y:0), animated: true)
    }
    //scrollview代理，用来判断滚动方向
    func scrollViewDidScroll(scrollView: UIScrollView) {
        switch type {
        case .Image:
            changeIndexWith(imageArr)
        default:
            changeIndexWith(urlArr)
        }
        
    }
    //通过scrollview偏移量确定index的值
    private func changeIndexWith(arr:[AnyObject]) {
        if arr.count == 0 {
            return
        }
        if scrollView!.contentOffset.x<=0 {
            index -= 1
            if index<0 {
                index = arr.count-1;
            }
            setImages()
        }else if scrollView!.contentOffset.x>=frame.size.width*2{
            index += 1;
            if index>arr.count-1 {
                index = 0;
            }
            setImages()
        }
    }
    
    //scrollview代理，用于在手指拖动scrollview时关闭定时器
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        closeTimer()
    }
    private func closeTimer(){
        timer?.invalidate()
        timer = nil
    }
    //scrollview代理，手指离开时开启一个新的定时器
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        openTimer()
    }
    private func openTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(startScroll), userInfo: nil, repeats: true)
    }
}
