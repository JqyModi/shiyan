//
//  ZiXunDetailVIewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import SVProgressHUD

class ZiXunDetailVIewController: YMBaseViewController {
    
        var content: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = view.bounds
      
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
//        webView.siz
        
       let html = content
        webView.loadHTMLString(html as! String, baseURL: nil)
        
        
        webView.delegate = self
        view.addSubview(webView)
        
        print("fl url:",content)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ZiXunDetailVIewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.setStatus("正在加载...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
  
        let jsString :String = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"
        webView.stringByEvaluatingJavaScript(from: jsString)

     
//        jsString = "document.getElementsByTagName('body')[0].style.background='#fce6c9'"
//        webView.stringByEvaluatingJavaScriptFromString(jsString)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
}

