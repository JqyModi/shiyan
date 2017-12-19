//
//  YMTMALLViewController.swift
//  GST_SY
//

import UIKit

class YMTMALLViewController: YMBaseViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var product: YMProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
     
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        let url = URL(string: product!.purchase_url!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    fileprivate func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkUserType_backward_9x15_"), style: .plain, target: self, action: #selector(navigationBackClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "GiftShare_icon_18x22_"), style: .plain, target: self, action: #selector(shareBBItemClick))
    }
    
    func shareBBItemClick() {
        YMActionSheet.show()
    }
    
    func navigationBackClick() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMTMALLViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
