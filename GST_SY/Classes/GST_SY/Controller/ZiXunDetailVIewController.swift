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
    
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = view.bounds
        
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        
        let html = "http://shiyan360.cn/api/news?id=" + content!
        //        webView.loadHTMLString(html as! String, baseURL: nil)
        webView.loadRequest(URLRequest(url: URL(string: html)!))
        
        webView.delegate = self
        view.addSubview(webView)
        
        print("fl url:",content)
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
        
        let jsString :String = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"
        webView.stringByEvaluatingJavaScript(from: jsString)
        
        
        //        jsString = "document.getElementsByTagName('body')[0].style.background='#fce6c9'"
        //        webView.stringByEvaluatingJavaScriptFromString(jsString)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
}

