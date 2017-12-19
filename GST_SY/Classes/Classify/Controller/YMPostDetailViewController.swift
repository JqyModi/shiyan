//
//  YMPostDetailViewController.swift
//  GST_SY
//

import UIKit

class YMPostDetailViewController: YMBaseViewController {

    var post: YMCollectionPost?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        let url = URL(string: post!.content_url!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension YMPostDetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print(webView.stringByEvaluatingJavaScript(from: "document.documentElement.innerHTML"))
    }
}
