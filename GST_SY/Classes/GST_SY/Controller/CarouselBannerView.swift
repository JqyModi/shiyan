//
//  CarouselBannerView.swift
//

import UIKit
import Kingfisher
protocol CarouselBannerViewDelegate  : NSObjectProtocol{

    func  numberOfImageInScrollView (toScrollView scrollView : CarouselBannerView) ->Int
    

    func  scrollView (toScrollView scrollView : CarouselBannerView ,andImageAtIndex  index: NSInteger ,  forImageView  imageView : UIImageView)

    func  scrollView (toScrollView scrollView : CarouselBannerView, didTappedImageAtIndex  index : NSInteger)
}
class CarouselBannerView: UIView ,UIScrollViewDelegate,UIGestureRecognizerDelegate  {
    var bannerDelegate  : CarouselBannerViewDelegate!
    var bgScrollView = UIScrollView()
    var imageView1 = UIImageView()
    var imageView2 = UIImageView()
    var imageView3 = UIImageView()
    var pageControl = UIPageControl()
    var numberForImage = Int()
    var scrollTimer = Timer()
    var currentPage = NSInteger()
    var shouldAutoScoll = Bool()
    var scrollInterval  = TimeInterval()
    var isInitLayoutSubVies = Bool()
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.bgScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.bgScrollView .isPagingEnabled = true
        self.bgScrollView .showsHorizontalScrollIndicator = false
        self.bgScrollView .showsVerticalScrollIndicator = false
        self.addSubview(self.bgScrollView)
        self.setUpInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpInit (){
        self.bgScrollView.delegate = self
        self.shouldAutoScoll   = true;
        //      self.backgroundColor = UIColor.blueColor()
        self.numberForImage = 1
        self.scrollInterval = 2.5
        self.imageView1 = UIImageView.init(frame:self.bounds)
        self.imageView1.backgroundColor=UIColor.red
        self.imageView2 = UIImageView.init(frame:self.bounds)
        self.imageView2.backgroundColor=UIColor.green
        self.imageView3 = UIImageView.init(frame:self.bounds)
        self.imageView3.backgroundColor=UIColor.blue
        imageView1.clipsToBounds = true
        imageView2.clipsToBounds = true
        imageView3.clipsToBounds = true
        self.bgScrollView.addSubview(imageView1)
        self.bgScrollView.addSubview(imageView2)
        self.bgScrollView.addSubview(imageView3)
        
        self.imageView2.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CarouselBannerView.toTapImageView(_:)))
        self.imageView2.addGestureRecognizer(tapGesture)
        
        self.pageControl = UIPageControl.init(frame: CGRect(x: (self.frame.size.width - 200)/2,y: self.frame.size.height-30, width: 200, height: 20))
        self.addSubview(self.pageControl)
        
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        //        if(self.shouldAutoScoll){
        //            self.setUpAutoScrollTimer()
        //        }
    }
    
    func toTapImageView ( _ gesture : UITapGestureRecognizer){
        self.bannerDelegate?.scrollView(toScrollView: self, didTappedImageAtIndex: self.currentPage)
    }
    
    func setUpAutoScrollTimer(){
        if (!self.scrollTimer.isValid) {
            self.scrollTimer = Timer(timeInterval: self.scrollInterval, target: self, selector: #selector(CarouselBannerView.autoScrollTimerFired(_:)), userInfo:nil , repeats: true)
            RunLoop.current.add(self.scrollTimer, forMode: RunLoopMode.commonModes)
        }
    }
    
    func autoScrollTimerFired (_ time : Timer){
        UIView.animate(withDuration: 0.5, animations:{
            self.bgScrollView.contentOffset =  CGPoint(x: 2 * self.bounds.size.width, y: 0)} , completion:{finshed  in  self.scrollViewDidEndDecelerating(self.bgScrollView)
        })
    }
    
    override func layoutSubviews() {
        if (!isInitLayoutSubVies){
            
            self.bgScrollView.contentOffset    = CGPoint(x: self.frame.size.width, y: 0)
            self.imageView1.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.imageView2.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width,height: self.frame.size.height )
            self.imageView3.frame = CGRect(x: self.frame.size.width*2, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.bgScrollView.contentSize = CGSize(width: 3*self.frame.size.width, height: self.frame.size.height)
            isInitLayoutSubVies = true
            self.reloadIamge()
        }
        super.layoutSubviews()
    }
    
    func reloadIamge(){
        self.pageControl.currentPage = self.currentPage
        
        self.bannerDelegate!.scrollView(toScrollView: self, andImageAtIndex: self.currentPage, forImageView: self.imageView2)
        self.bannerDelegate!.scrollView(toScrollView: self, andImageAtIndex: self.currentPage == (self.numberForImage - 1) ? 0 : self.currentPage + 1 , forImageView: self.imageView3)
        self.bannerDelegate?.scrollView(toScrollView: self, andImageAtIndex: self.currentPage == 0 ? (self.numberForImage - 1) : self.currentPage - 1, forImageView: self.imageView1)
        
        
    }
    
    //MARK:  scrollViewDelegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(self.shouldAutoScoll){
            self.setUpAutoScrollTimer()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollTimer.invalidate()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  contentOffsetX : CGFloat  = self.bgScrollView.contentOffset.x
        let  pageNumber   =  Int(contentOffsetX / self.frame.width)
        if (pageNumber == 0){
            self.currentPage = self.currentPage == 0 ? (self.numberForImage-1) : self.currentPage - 1
        }
        else if (pageNumber == 2){
            self.currentPage = self.currentPage == (self.numberForImage - 1) ? 0 : self.currentPage + 1
        }
        
        self.reloadIamge()
        self.bgScrollView.contentOffset = CGPoint(x: self.bounds.size.width, y: 0)
        
    }
    func  reloadData() {
        let cout : Int = self.bannerDelegate.numberOfImageInScrollView(toScrollView: self)
        
        self.numberForImage = cout
        self.setUpAutoScrollTimer()
        if(self.numberForImage == 1 || self.numberForImage == 0){
            self.bgScrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
            self.scrollTimer.invalidate()
            self.pageControl.isHidden = true
        }else{
            self.bgScrollView.contentSize = CGSize(width: 3*self.frame.size.width, height: self.frame.size.height)
            self.pageControl.isHidden = false
        }
        
        self.pageControl.numberOfPages = self.numberForImage
        self .reloadIamge()
    }
    
    
}
