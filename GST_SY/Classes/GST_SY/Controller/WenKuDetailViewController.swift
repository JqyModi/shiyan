//
//  WenKuDetailViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import SVProgressHUD

class WenKuDetailViewController: YMBaseViewController {
    
    var fileurl: NSString!
    var filename: NSString!
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = view.bounds
//        webView.frame = CGRectMake(0, 0, 375, 600)
        webView.backgroundColor = UIColor.lightGray
       
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        
//        let fileUrl = NSURL(fileURLWithPath: fileurl as String)
//        let request = NSURLRequest(URL: fileUrl)
        
        let url = URL(string: fileurl as String)
        let request = URLRequest(url: url!)
        
//        let baseUrl = "http://api.idocv.com/view/url?url=" + String(fileurl)
//        let url = NSURL(string: baseUrl as String)
//        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
        webView.delegate = self
        view.addSubview(webView)
        view.contentMode = .scaleToFill
    }
    
    
}

extension WenKuDetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.setStatus("正在加载...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
     
        var jsString: String = ""
        jsString = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"
        webView.stringByEvaluatingJavaScript(from: jsString)
        
//        jsString = "document.getElementsByTagName('table')[0].style.width='auto'"
//        webView.stringByEvaluatingJavaScriptFromString(jsString)
//
//        jsString = "document.getElementsByTagName('table')[0].style.borderColor= '#ffaaaa'"
//        webView.stringByEvaluatingJavaScriptFromString(jsString)
        
//        setWebViewHtmlImageFitPhone(webView)
        
        jsString = "document.getElementsByTagName('body')[0].style.background='#e2e2e2'"
        webView.stringByEvaluatingJavaScript(from: jsString)
        
//        jsString = "document.getElementsByTagName('table')[0].style.background='#f2a2a2'"
//        webView.stringByEvaluatingJavaScript(from: jsString)

    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func setWebViewHtmlImageFitPhone(_ webView: UIWebView){
        let width = UIScreen.main.bounds.width
        let js = NSString(format: "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function operationTable() {var tbody = document.getElementsByTagName('tbody')[0];document.getElementsByTagName('table')[0].remove();var table =document.createElement('table');table.appendChild(tbody);table.style.width='500px';table.style.background='#f2a2a2';document.getElementsByTagName('body')[0].appendChild(table);document.getElementsByTagName('table')[0].style.width = '100%';document.getElementsByTagName('table')[0].style.width = '100%';document.getElementsByTagName('table')[0].style.background='#f2a2a2';}\";document.getElementsByTagName('head')[0].appendChild(script);", width)
        webView.stringByEvaluatingJavaScript(from: js as String)
        webView.stringByEvaluatingJavaScript(from: "operationTable();")
    }
    
    /*
     方式1.获取手机屏幕宽度并设置给webViewHtml
     方式2.网页端加<style>img{width: 100%;}</style>
     */
    
    /*
    func setWebViewHtmlImageFitPhone(){
        let width = SCREEN_WIDTH
        let js = NSString(format: "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function ResizeImages() { var myimg,oldwidth;var maxwidth = '%f';for(i=0;i <document.images.length;i++){myimg = document.images[i];if(myimg.width > maxwidth){oldwidth = myimg.width;myimg.width = maxwidth;}}}\";document.getElementsByTagName('head')[0].appendChild(script);", width)
        contentWebView.stringByEvaluatingJavaScript(from: js as String)
        contentWebView.stringByEvaluatingJavaScript(from: "ResizeImages();")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        setWebViewHtmlImageFitPhone()
    }
     */
}
