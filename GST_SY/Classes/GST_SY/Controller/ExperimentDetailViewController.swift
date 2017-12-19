//
//  ExperimentViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import SVProgressHUD

class ExperimentDetailViewController: YMBaseViewController {
    
    var expurl: NSString!
    var expname: NSString!
    let webView = UIWebView()

    var isFullScreen:Bool {
        get {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        webView.frame = view.bounds
//frame: CGRectMake(0, 0, SCREENH, SCREENW)
        

        
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        
        
        let url = URL(string: expurl as String)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        
        webView.delegate = self
        view.addSubview(webView)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            webView.frame = CGRect(x: 0, y: 0, width: SCREENH, height: SCREENW)
//            self.navigationController?.navigationBarHidden=true
            navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)

        } else {
            print("Portrait")
            webView.frame = CGRect(x: 0, y: 0, width: SCREENW, height: SCREENH)
            self.navigationController?.isNavigationBarHidden=false
            

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden=true
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
//            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
//            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
//            UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.LandscapeRight, animated: false)

    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
}

extension ExperimentDetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.setStatus("正在加载...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
  
        let jsString :String = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"
        webView.stringByEvaluatingJavaScript(from: jsString)
        
       
        //  jsString = "document.getElementsByTagName('body')[0].style.background='#fce6c9'"
        //  webView.stringByEvaluatingJavaScriptFromString(jsString)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
