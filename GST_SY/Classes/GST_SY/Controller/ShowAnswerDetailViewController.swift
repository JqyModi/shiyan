//
//  ShowAnswerDetailViewController.swift
//  GST_SY
//
//  Created by mac on 17/7/22.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import SwiftyJSON
import UITableView_FDTemplateLayoutCell
/*
 显示答案详情页
*/

private let Indetifier = "cell"

class ShowAnswerDetailViewController: UIViewController {
    //定义变量
    var answers = NSMutableDictionary()
    var submitData = NSMutableDictionary()
    var xcontent = NSMutableDictionary()
    var tcontent = NSMutableDictionary()
    var jcontent = NSMutableDictionary()
    
    var paperId: String?
    var paperName: String?
    
    var papers = [Paper]()
    var data:Array <Paper> = []
    var tableView: UITableView?
    var cell: ShowAnswerDetailTableViewCell?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTableView() {
//        tableView = UITableView(frame: CGRectMake(0,(self.navigationController?.navigationBar.height)!+20,self.view.width,self.view.height-(self.navigationController?.navigationBar.height)!-20))
        tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(tableView!)
        tableView!.delegate = self
        tableView!.dataSource = self
        //注册复用class
        tableView!.register(ParseTableViewCell.classForCoder(), forCellReuseIdentifier: Indetifier)
        tableView!.tableFooterView = UIView()
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView!.separatorColor = UIColor.red
        tableView!.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    private func prepareTableView() {
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView?.tableFooterView = UIView()
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView?.separatorColor = UIColor.red
        self.tableView?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.view.addSubview(tableView!)
        
        self.tableView?.register(ParseTableViewCell.self, forCellReuseIdentifier: Indetifier)
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        //设置行高
        self.tableView?.rowHeight = 200
        
        //设置分割线
        self.tableView?.separatorStyle = .none
        
        //自动计算行高：Cell自动布局1
        //1.设置估计值
        self.tableView?.estimatedRowHeight = (tableView?.rowHeight)!
        //2.设置自动计算
        self.tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    func initView(){
        //初始化背景及导航栏
        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.backgroundColor = YMGlobalGreenColor()
//        self.setupTableView()
        prepareTableView()
        
        self.submitDataToServer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        
    }
    
    func submitDataToServer(){
        //封装需要提交到服务器的数据
        let defaults : UserDefaults = UserDefaults.standard
        let sid = defaults.value(forKey: "userId")
        
        self.submitData.setValue("0", forKey: "hour")
        self.submitData.setValue("10", forKey: "minute")
        self.submitData.setValue(self.paperId, forKey: "cp_id")
        self.submitData.setValue(sid, forKey: "sid")
        self.submitData.setValue(self.paperName, forKey: "title")
        var x = 1;
        var t = 1;
        var j = 1;
        if PaperAnswers.count == data.count {
            for i in 0 ..< PaperAnswers.count {
                let type = ((PaperAnswers.value(forKey: String(i)) as AnyObject).value(forKey: "type") as AnyObject).description!
                let answer = ((PaperAnswers.value(forKey: String(i)) as AnyObject).value(forKey: "user") as AnyObject).description!
                var dictTemp = NSMutableDictionary()
                
                switch type {
                case "xz":
                    dictTemp.setValue(answer, forKey: "user")
                    self.xcontent.setValue(dictTemp, forKey: String(x))
                    x = x + 1
                    break
                case "tk":
                    let arrAnswer = answer.components(separatedBy: ";")
                    dictTemp.setValue(arrAnswer, forKey: "user")
                    self.tcontent.setValue(dictTemp, forKey: String(t))
                    t = t + 1
                    break
                case "jd":
                    dictTemp.setValue(answer, forKey: "user")
                    self.jcontent.setValue(dictTemp, forKey: String(j))
                    j = j + 1
                    break
                default:
                    break
                }
            }
            
        }
        let xStr = self.xcontent
        let tStr = self.tcontent
        let jStr = self.jcontent
        
        self.submitData.setValue(xStr, forKey: "xcontent")
        self.submitData.setValue(tStr, forKey: "tcontent")
        self.submitData.setValue(jStr, forKey: "jcontent")
        
        let json = JSON.init(self.submitData)
        let str = json.description
        print("提交到服务器的数据：str = \(str)")
        
        YMNetworkTool.shareNetworkTool.submitAnswer(str)
    }


    
    func fillData(_ cell: ShowAnswerDetailTableViewCell, row: Int) {
        cell.selectionStyle = .none
        cell.pImg!.kf_setImage(with: URL(string: ""))
//        cell.pImg!.kf_setImageWithURL(URL(string: ""))
        
        //填充数据
        let orgData = self.data[row]
        let tHeight = orgData.title.stringHeightWith(14, width: 359)
        print("即将移除图片时的title高度 = \(tHeight)")
        
//        cell.pImgHeightLayout.constant = 0
        //获取到用户填写的答案数据
        let key = "answer"+"\(row)"
        let userData = (PaperAnswers.value(forKey: String(row)) as AnyObject).value(forKey: "user")
        print("userData  = \(userData)")
        
        cell.orgData = orgData
        cell.userData = (userData as AnyObject).description!
        
        //设置答案的显示隐藏
        if orgData.A != nil {  //说明该题是选择题
            cell.pAnswer1!.isHidden = false
            cell.pAnswer2!.isHidden = false
            cell.pAnswer3!.isHidden = false
            cell.pAnswer4!.isHidden = false
            cell.pTkAnswer!.isHidden = true
            
            cell.pAnswer1!.text = "A. "+(orgData.A)!
            cell.pAnswer2!.text = "B. "+(orgData.B)!
            cell.pAnswer3!.text = "C. "+(orgData.C)!
            cell.pAnswer4!.text = "D. "+(orgData.D)!
            
            cell.pAnswer1!.adjustsFontSizeToFitWidth = true
            cell.pAnswer2!.adjustsFontSizeToFitWidth = true
            cell.pAnswer3!.adjustsFontSizeToFitWidth = true
            cell.pAnswer4!.adjustsFontSizeToFitWidth = true
        }else{  //设置填空题答案
            
            cell.pTkAnswer!.isHidden = false
            cell.pAnswer1!.isHidden = true
            cell.pAnswer2!.isHidden = true
            cell.pAnswer3!.isHidden = true
            cell.pAnswer4!.isHidden = true
            
            cell.pTkAnswer!.text = cell.orgData?.right
            cell.pTkAnswer!.adjustsFontSizeToFitWidth = true
        }
        //显示题目
        cell.pTitle!.text = "\(row + 1). " + (cell.orgData?.title)!
        cell.pTitle!.adjustsFontSizeToFitWidth = true
        //显示图片
        var url = (orgData.img)!
        if url != "" {
            url = HOST + url
            url = url.replacingOccurrences(of: "\"", with: "")
            url = url.replacingOccurrences(of: " ", with: "")
            
            cell.pImg!.kf_setImage(with: URL(string: url))
//            cell.pImg!.kf_setImageWithURL(URL(string: url))
        }else{
            //移除掉当前的图片控件
            if cell.pImg != nil {
                
            }
            
        }
        //显示用户选择的答案
        cell.pUserAnswer!.text = "您的答案：" + (cell.userData)!
        cell.pUserAnswer!.adjustsFontSizeToFitWidth = true
        
        //显示解析
        cell.pJiexi!.text = cell.orgData?.jiexi.replacingOccurrences(of: "解析:", with: "")
        cell.pJiexi!.text = cell.orgData?.jiexi.replacingOccurrences(of: "解析：", with: "")
        cell.pJiexi!.text = cell.orgData?.jiexi.replacingOccurrences(of: "【分析】", with: "")
        cell.pJiexi!.adjustsFontSizeToFitWidth = true
    }
    
}

extension ShowAnswerDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let row = indexPath.row
//        let model = self.data[row]
//
//        let userData = ((PaperAnswers.value(forKey: String(row)) as AnyObject).value(forKey: "user") as AnyObject).description!
//        model.userRight = userData
//
//        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
//        //        return tableView.cellHeightForIndexPath(indexPath, model: model, keyPath: "model", cellClass: ShowAnswerDetailTableViewCell.classForCoder(), contentViewWidth: SCREENW)
//
//        return self.cellHeight(for: indexPath, cellContentViewWidth: SCREENW, tableView: tableView)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取可复用的Cell
//        var cell2 = tableView.dequeueReusableCell(withIdentifier: Indetifier) as? ShowAnswerDetailTableViewCell
//        let row = indexPath.row
//        let model = self.data[row]
//
//        let userData = ((PaperAnswers.value(forKey: String(row)) as AnyObject).value(forKey: "user") as AnyObject).description!
//        model.userRight = userData
//        cell2!.setModelWithPaper(model)
//        cell2!.useCellFrameCache(with: indexPath, tableView: tableView)
//        return cell2!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Indetifier, for: indexPath) as? ParseTableViewCell
        cell?.paper = data[indexPath.row]
        return cell!
    }
}
