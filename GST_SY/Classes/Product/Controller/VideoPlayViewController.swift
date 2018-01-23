//
//  VideoPlayViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/10.
//  Copyright © 2016年 hrscy. All rights reserved.
//
import UIKit
import BMPlayer
import NVActivityIndicatorView
var videourl: NSString!
var videoname :NSString!
class VideoPlayViewController: UIViewController {
    
    //    @IBOutlet weak var player: BMPlayer!
    
    var player: BMPlayer!
    
    var index: IndexPath!
    var videourl: NSString!
    var videoname: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GSTGlobalBgColor()
//        setupPlayerManager()
        preparePlayer()
        setupPlayerResource()
        debugPrint("vc name:",videoname)
        debugPrint("vc url:",videourl)
        BMPlayerConf.allowLog = true
        
        
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func preparePlayer() {
        player = BMPlayer()
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        // Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        self.view.layoutIfNeeded()

    }
    

    func setupPlayerResource() {
        player.setVideo(resource: BMPlayerResource(url: URL(string: videourl as String)!, name: videoname as String, cover: nil, subtitle: nil))
//        player.playWithURL(URL(string: videourl as String)!, title: videoname as String)
    }
    
    
    
    func resetPlayerManager() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        //显示导航栏
        self.navigationController?.isNavigationBarHidden=false
        player.pause(allowAutoPlay: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航栏
        self.navigationController?.isNavigationBarHidden=true
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
  
        player.autoPlay()
    }
    
    deinit {
   
        player.prepareToDealloc()
        debugPrint("VideoPlayViewController Deinit")
    }
    
}
