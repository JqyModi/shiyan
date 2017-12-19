//
//  YMProductDetailBottomView.swift
//  GST_SY

import UIKit
import SnapKit

let commentCellID = "commentCellID"

class YMProductDetailBottomView: UIView {
    
    var comments = [YMComment]()
    
    var product: YMProduct? {
        didSet {
            weak var weakSelf = self
 
            YMNetworkTool.shareNetworkTool.loadProductDetailData(product!.id!) { (productDetail) in
                weakSelf!.choiceButtonView.commentButton.setTitle("评论(\(productDetail.comments_count!))", for: UIControlState())
                weakSelf!.webView.loadHTMLString(productDetail.detail_html!, baseURL: nil)
            }

            YMNetworkTool.shareNetworkTool.loadProductDetailComments(product!.id!) { (comments) in
                weakSelf!.comments = comments
                weakSelf!.tableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
 
        addSubview(choiceButtonView)
        
        addSubview(tableView)
        
        addSubview(webView)
        
        choiceButtonView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: SCREENW, height: 44))
            make.top.equalTo(self)
        }
        
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(choiceButtonView.snp_bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(choiceButtonView.snp_bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView()
       
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        webView.delegate = self
        return webView
    }()
    
    fileprivate lazy var choiceButtonView: YMDetailChoiceButtonView = {
        let choiceButtonView = YMDetailChoiceButtonView.choiceButtonView()
        choiceButtonView.delegate = self
        return choiceButtonView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        let nib = UINib(nibName: String(describing: YMCommentCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: commentCellID)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        return tableView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YMProductDetailBottomView: YMDetailChoiceButtonViewDegegate, UIWebViewDelegate, UITableViewDataSource {
    
    // MARK: - YMDetailChoiceButtonViewDegegate
    func choiceIntroduceButtonClick() {
        tableView.isHidden = true
        webView.isHidden = false
    }
    
    func choicecommentButtonClick() {
        tableView.isHidden = false
        webView.isHidden = true
        
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellID) as! YMCommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
}
