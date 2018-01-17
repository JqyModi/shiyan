//
//  VoteDetailViewController.swift
//  Vote
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import BMPlayer

class VoteDetailViewController: UIViewController {

    var pro: TimeInterval = 0
    var total: TimeInterval = 0
    
    @objc private func voteBtnDidClick() {
        debugPrint("当前播放时长：\(proLabel?.text)")
//        debugPrint("当前滑杆进度：\(videoSlider?.value)")
        //当前票数加1
        var msg = ""
        let text = totalLabel.text!
        let s = "当前票数："
        let totalStr = text.substring(from: s.endIndex)
        
        let alert = UIAlertController(title: "温馨提示", message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            debugPrint(#function)
        }
        let ok = UIAlertAction(title: "确定", style: .destructive) { (action) in
            debugPrint(#function)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        
        if pro != total {
            alert.message = "为她投票前需要先观看完该视频 ~ "
        } else if Int(totalStr) == Int((vote?.piao)!)! + 1 {
            alert.message = "您已经为她投上一票，请勿重复投票 ~ 如果需要再次为她投票，请重新观看该视频 ~ 谢谢"
            alert.addAction(ok)
        }else {
            //获取当前票数刷新界面
            let url = "http://shiyan360.cn/api/vote_setinc"
            NetworkTools.sharedSingleton.requestVote(urlStr: url, id: (vote?.id!)!, completionHandler: { (result) in
                if let voteCount = result!["piao"] as? String {
                    debugPrint("voteCount ----> \(voteCount)")
                    DispatchQueue.main.async {
                        self.totalLabel.text = "当前票数：\(voteCount)"
                    }
                }
            })
            alert.message = "投票成功 ~ 您可以跳转到投票页查看她当前的排名情况，是否跳转？"
            alert.addAction(ok)
        }
        
        //弹出一个提示框
        self.present(alert, animated: true, completion: nil)
    }
    //播放器控制层
    var proLabel: UILabel?
//    var videoSlider: ASValueTrackingSlider?
    //活动是否过期
    var isOverdue = false
    
    var vote: VoteListModel? {
        didSet {
            let url = URL(string: ("http://shiyan360.cn" + (vote?.video_url!)!))
            debugPrint("url ----> \(url?.absoluteString)")
            //基本播放器设置
            
            // Back button event
            videoPlayer.backBlock = { [unowned self] (isFullScreen) in
                if isFullScreen == true { return }
//                let _ = self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            
            let asset = BMPlayerResource(url: url!, name: (vote?.name!)!)
            videoPlayer.setVideo(resource: asset)
            
            //监听播放进度
            videoPlayer.playTimeDidChange = { (time1, time2) in
                debugPrint("time1 = \(time1) : time2 = \(time2)")
                self.pro = time1
                self.total = time2
            }
        }
    }
    
    //布局载入时调用
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("活动截止情况：\(isOverdue)")
        if isOverdue {
            voteBtn.setTitle("活动已结束 ~", for: .normal)
            voteBtn.isEnabled = false
            //隐藏票数Label
            totalLabel.isHidden = true
        }
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        
        videoView.addSubview(videoPlayer)
        
        view.addSubview(videoView)
        view.addSubview(descLabel)
        view.addSubview(voteBtn)
        view.addSubview(totalLabel)
        
        videoView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(UIScreen.main.bounds.height/3)
        }
        
//        videoPlayer.snp.makeConstraints { (make) in
//            make.top.equalTo(videoView).offset(10)
//            make.left.right.equalTo(videoView)
//            // Here a 16:9 aspect ratio, can customize the video aspect ratio
//            make.height.equalTo(videoPlayer.snp.width).multipliedBy(9.0/16.0)
//        }
        
        videoPlayer.snp.makeConstraints { (make) in
            make.top.equalTo(videoView).offset(20)
            make.left.right.equalTo(videoView)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(videoPlayer.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(videoView).offset(10)
            make.right.equalTo(videoView).offset(-10)
            make.top.equalTo(videoView.snp.bottom).offset(10)
        }
        
        voteBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(voteBtn.snp.bottom).offset(10)
            make.centerX.equalTo(voteBtn)
            make.width.equalTo(voteBtn)
            make.height.equalTo(voteBtn)
        }
        
        //数据展示
        descLabel.text = "简介：" + (vote?.remark!)!
        voteBtn.setTitle("为她投票", for: .normal)
        totalLabel.text = "当前票数：" + (vote?.piao!)!
        
        //点击事件
        voteBtn.addTarget(self, action: "voteBtnDidClick", for: .touchUpInside)
    }
    
    //懒加载一个视频播放器
    private lazy var videoPlayer: BMPlayer = {
        let video = BMPlayer()
//        let playerModel = ZFPlayerModel()
//        video.playerControlView(nil, playerModel: playerModel)
        return video
    }()
    
    private lazy var videoView: UIView = {
        let v = UIView()
//        v.backgroundColor = UIColor.magenta
        return v
    }()
    
    private lazy var descLabel: UILabel = {
        let desc = UILabel()
        desc.textColor = UIColor.brown
        desc.sizeToFit()
        desc.textAlignment = .center
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.numberOfLines = 0
        return desc
    }()
    
    private lazy var totalLabel: UILabel = {
        let total = UILabel()
        total.textColor = UIColor.brown
        total.sizeToFit()
        total.textAlignment = .center
        total.font = UIFont.systemFont(ofSize: 14)
        return total
    }()
    
    private lazy var voteBtn: UIButton = {
        let vote = UIButton()
        vote.setTitleColor(UIColor.white, for: .normal)
        vote.backgroundColor = UIColor.orange
        vote.sizeToFit()
        vote.titleLabel?.textAlignment = .center
        vote.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //默认不可点击
//        vote.isEnabled = false
//        vote.backgroundColor = UIColor.lightGray
        return vote
    }()
}

