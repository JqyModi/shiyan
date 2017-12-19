//
//  YMDetailViewController.swift
//  GST_SY
//
//

import UIKit
import SVProgressHUD

class YMDetailViewController: YMBaseViewController {

    var homeItem: YMHomeItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = view.bounds
       
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        let url = URL(string: homeItem!.content_url!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        webView.delegate = self
        view.addSubview(webView)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMDetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.setStatus("正在加载...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}


