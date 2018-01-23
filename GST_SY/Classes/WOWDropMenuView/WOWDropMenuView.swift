//
//  WOWDropMenuView.swift
//  Wow
//

import Foundation
import UIKit
import SnapKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height


struct WOWDropMenuSetting {
    
    static var columnTitles = ["下拉菜单"]
    
    static var rowTitles =  [
                                ["尖叫君","尖叫君"]
                            ]
    static var columnTitleFont:UIFont = UIFont.init(name:"HelveticaNeue-Medium", size:13)!
    
    static var cellHeight:CGFloat = 40
    
    
    static var columnEqualWidth:Bool = false
    
    static var maxShowCellNumber:Int = 4
    
    static var cellTextLabelColor:UIColor = UIColor.black
    
    static var cellTextLabelSelectColoror:UIColor = UIColor.black
    
    static var tableViewBackgroundColor:UIColor = UIColor.white
    
    static var markImage:UIImage? = UIImage(named:"duihao")
    
    static var showDuration:TimeInterval = 0.3
    
    static var cellSelectionColor:UIColor = UIColor(colorLiteralRed: 255/255.0, green: 230/255.0, blue: 0/255.0, alpha: 1)
    
   
    fileprivate static var columnNumber:Int = 0
}


protocol DropMenuViewDelegate:class{
    func dropMenuClick(_ column:Int,row:Int)
}



class WOWDropMenuView: UIView {
    fileprivate var headerView: UIView!
    fileprivate var backView:UIView!
    fileprivate var bottomButton:UIButton!
    fileprivate var currentColumn:Int = 0
    fileprivate var show:Bool = false
    fileprivate var columItemArr = [WOWDropMenuColumn]()
    fileprivate var showSubViews = [UIView]()
    //存放的是每一列正在选择的title  row = value
    fileprivate var columnShowingDict = [Int:String]()
    
    weak var delegate:DropMenuViewDelegate?
    
    fileprivate var expandTableViewHeight = CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight
    
    fileprivate lazy var tableView:UITableView = {
        let v = UITableView(frame:CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0), style:.plain)
        v.delegate = self
        v.dataSource = self
        return v
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        configSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initData(){
        assert(WOWDropMenuSetting.columnTitles.count == WOWDropMenuSetting.rowTitles.count,"其中一列的list数据为空")
        WOWDropMenuSetting.columnNumber = WOWDropMenuSetting.columnTitles.count
        for (index,title) in WOWDropMenuSetting.columnTitles.enumerated() {
            columnShowingDict[index] = title
        }
    }
    
    fileprivate func configSubView(){
        backgroundColor = UIColor.white
        configHeaderView()

        let line = UIView()
        line.backgroundColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1)
        addSubview(line)
        line.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf).offset(0)
                make.height.equalTo(0.5)
            }
        }
        bottomButton = UIButton(type:.system)
        bottomButton.frame = CGRect(x: 0, y: frame.height-2, width: frame.width,height: 21)
        bottomButton.setBackgroundImage(UIImage(named: "icon_chose_bottom"), for: UIControlState())
        bottomButton.addTarget(self, action:#selector(bottomButtonClick(_:)), for:.touchUpInside)
        bottomButton.isHidden = true
        
        
        backView = UIView(frame:CGRect(x: 0,y: frame.height,width: frame.width,height: UIScreen.main.bounds.size.height))
        backView.isHidden = false
        backView.alpha = 0

        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: backView.frame.size.width, height: backView.frame.size.height)
        backView.addSubview(blurView)
    
        let tap = UITapGestureRecognizer(target: self, action:#selector(backTap))
        backView.addGestureRecognizer(tap)
        showSubViews = [bottomButton,backView,tableView]
    }
    
    fileprivate func configHeaderView(){
        headerView = UIView(frame: CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height))
        for (index,title) in WOWDropMenuSetting.columnTitles.enumerated() {
            let columnItem = Bundle.loadResourceName(String(describing: WOWDropMenuColumn.self)) as! WOWDropMenuColumn
            columnItem.titleButton.setTitle(title, for: UIControlState())
            columnItem.titleButton.setTitleColor(GSTGlobalFontColor(), for: UIControlState())
            
            columnItem.titleButton.addTarget(self, action:#selector(columnTitleClick(_:)), for:.touchUpInside)
            columnItem.titleButton.tag = index
            headerView.addSubview(columnItem)
            if WOWDropMenuSetting.columnEqualWidth {
                let columnWidth = (UIScreen.main.bounds.size.width - 30) / CGFloat(WOWDropMenuSetting.columnTitles.count)
                if index == 0 {
                    columnItem.snp_makeConstraints({ (make) in
                        make.left.top.bottom.equalTo(headerView).offset(0)
                        make.width.equalTo(columnWidth)
                    })
                }else{
                    columnItem.snp_makeConstraints({ (make) in
                        make.left.equalTo(columItemArr[index - 1].snp_right).offset(5)
                        make.top.bottom.equalTo(headerView).offset(0)
                        make.width.equalTo(columnWidth)
                        make.centerY.equalTo(headerView)
                    })
                }
            }else{
                if index == 0 {
                    columnItem.snp_makeConstraints({ (make) in
                        make.left.top.bottom.equalTo(headerView).offset(0)
                    })
                }else{
                    columnItem.snp_makeConstraints({ (make) in
                        make.left.equalTo(columItemArr[index - 1].snp_right).offset(5)
                        make.top.bottom.equalTo(headerView).offset(0)
                        make.centerY.equalTo(headerView)
                    })
                }
            }

            columItemArr.append(columnItem)
        }
        self.addSubview(headerView)
    }
    
    func  backTap(){
        hide()
    }
    
    func bottomButtonClick(_ sender:UIButton) {
        hide()
    }
    
    func columnTitleClick(_ btn:UIButton){
        show = !show
        if currentColumn != btn.tag {
            show = true
            UIView.animate(withDuration: WOWDropMenuSetting.showDuration, animations: {[weak self] () -> () in
                if let strongSelf = self {
                   strongSelf.columItemArr[strongSelf.currentColumn].arrowImageView.transform = CGAffineTransform.identity
                }
            })
        }else{
            
        }
        currentColumn = btn.tag
        if show {
//            showSubViews.forEach({ (view) in
//                view.removeFromSuperview()
//            })可以不这样做
            rotateArrow()
            tableView.isHidden = false
            backView.isHidden  = false
            bottomButton.isHidden = false
            tableView.frame = CGRect(x: 0, y: self.y + self.height,width: screenWidth, height: 0)
            bottomButton.frame = CGRect(x: 0,y: self.y + self.height,width: screenWidth,height: 21)
            backView.frame = CGRect(x: 0, y: self.y + self.height, width: screenWidth, height: screenHeight)
            self.superview?.addSubview(tableView)
            self.superview?.addSubview(bottomButton)
            self.superview?.addSubview(backView)
            self.superview?.insertSubview(backView, belowSubview: tableView)
            
            UIView.animate(withDuration: WOWDropMenuSetting.showDuration, animations: { 
                self.tableView.height = CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight
                
                self.bottomButton.y = self.tableView.frame.maxY - 1
                
                self.backView.alpha = 0.8
            })
        }else{
            hide()
        }
        tableView.reloadData()
    }
    
    fileprivate func rotateArrow() {
        UIView.animate(withDuration: WOWDropMenuSetting.showDuration, animations: {[weak self] () -> () in
            if let strongSelf = self {
               strongSelf.columItemArr[strongSelf.currentColumn].arrowImageView.transform = strongSelf.columItemArr[strongSelf.currentColumn].arrowImageView.transform.rotated(by: 180 * CGFloat(M_PI/180))
            }
        })
    }
    
    fileprivate func hide(){
        show = false
        UIView.animate(withDuration: WOWDropMenuSetting.showDuration, animations: {
            self.tableView.height = 0
            self.bottomButton.y -= CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight
            self.columItemArr[self.currentColumn].arrowImageView.transform = CGAffineTransform.identity
            self.backView.alpha = 0
            }, completion: { (ret) in
                self.tableView.isHidden = true
                self.bottomButton.isHidden = true
                self.backView.isHidden = true
                self.tableView.removeFromSuperview()
                self.bottomButton.removeFromSuperview()
                self.backView.removeFromSuperview()
        })
    }
    
}


extension WOWDropMenuView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = WOWDropMenuSetting.rowTitles.count
        debugPrint("下拉菜单Count ＝ \(count)")
        return WOWDropMenuSetting.rowTitles[currentColumn].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WOWDropMenuSetting.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "MenuCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier:cellID)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = UIColor.black
            let image = UIImage(named: "duihao")
            let markImageView = UIImageView(frame:CGRect(x: frame.width - (image?.size.width)! - 15,y: 0,width: (image?.size.width)!, height: (image?.size.height)!))
            markImageView.centerY = (cell?.contentView.centerY)!
            markImageView.tag = 10001
            markImageView.image = image
            cell?.contentView.addSubview(markImageView)
        }
        let titles = WOWDropMenuSetting.rowTitles[currentColumn]
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.textLabel?.textColor = columnShowingDict[currentColumn] == titles[indexPath.row] ? WOWDropMenuSetting.cellTextLabelSelectColoror : WOWDropMenuSetting.cellTextLabelColor
        if columnShowingDict[currentColumn] == titles[indexPath.row] {
            tableView.scrollToRow(at: indexPath, at:.none, animated: true)
        }
        cell?.contentView.viewWithTag(10001)?.isHidden = !(columnShowingDict[currentColumn] == titles[indexPath.row])
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = WOWDropMenuSetting.rowTitles[currentColumn][indexPath.row]
        columItemArr[currentColumn].titleButton.setTitle(title, for: UIControlState())
        columnShowingDict[currentColumn] = title
        hide()
        if let del = self.delegate {
            del.dropMenuClick(currentColumn, row: indexPath.row)
        }
    }
    
//    //因为有view在父试图之外，所以要加入响应  但是会阻碍外侧tableView的响应事件
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        var view = super.hitTest(point, withEvent: event)
//        if view == nil {
//            for v in self.subviews {
//                let p = v.convertPoint(point, fromView: self)
//                if  CGRectContainsPoint(v.bounds, p) {
//                    view = v
//                }
//            }
//        }
//        return view
//    }
    
}


public extension Bundle{
    static func loadResourceName(_ name:String!) -> AnyObject?{
        return  Bundle.main.loadNibNamed(name, owner: self, options: nil)?.last as AnyObject?
    }
}
