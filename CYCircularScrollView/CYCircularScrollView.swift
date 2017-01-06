//
//  CYCircularScrollView.swift
//  SDClientsPlatformSwift
//
//  Created by Peter Lee on 2016/12/21.
//  Copyright © 2016年 ZTESoft. All rights reserved.
//

import UIKit

let kCYScrollDefalutDuration:Double = 5.0;
let kCYScrollCellId = "kCYScrollCellId"

enum CYScrollDirection:Int {
    case vertical
    case horizontal
}

protocol CYCircularScrollProtocol {
    var cellClass:UICollectionViewCell.Type {get}
    var scrollDirection:CYScrollDirection {get}
    var isScrollEnabled:Bool {get}
    
    func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell
    func scrollToPage(_ page:Int)
}

class CYCircularScrollView : UICollectionReusableView, CYCircularScrollProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:property
    var cellClass:UICollectionViewCell.Type {
        return UICollectionViewCell.self
    }
    
    var scrollDirection:CYScrollDirection {
        return .horizontal
    }
    
    var isScrollEnabled:Bool {
        return true
    }
    
    var autoScrollInterval:Double = kCYScrollDefalutDuration{
        didSet{
            self.resetTimer()
        }
    }
    
    var didSelectClosure:((Int,Any)->())?
    
    var dataArray:[Any]? {
        didSet{
            if self.dataArray == nil {return}
            self.refresh()
        }
    }
    
    private var timer:Timer?
    
    lazy private var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection(rawValue:self.scrollDirection.rawValue)!
        
        let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = self.isScrollEnabled
        
        collectionView.register(self.cellClass, forCellWithReuseIdentifier: kCYScrollCellId)
        return collectionView
    }()
    
    //MARK: init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.confiugureConstraints()
    }
    
    convenience init(frame: CGRect, datas:[Any]?, didSelected:((Int,Any)->())?) {
        self.init(frame: frame)
        dataArray = datas
        didSelectClosure = didSelected
        self.refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func confiugureConstraints() {
        //Use SnapKit is much better, but I don't want to import too many frameworks...
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        let leftConst = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightConst = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let topConst = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConst = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([leftConst,rightConst,topConst,bottomConst])
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    //MARK:CYCircularScrollProtocol method, for override
    func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell {
        return cell;
    }
    
    //MARK:delegate method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.dataArray == nil {
            return 0
        }
        
        let number = self.dataArray!.count>1 ? self.dataArray!.count+2 : self.dataArray!.count
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCYScrollCellId, for: indexPath)
        
        let index = self.transferIndex(indexPath.row)
        
        let data = self.dataArray![index]
        
        cell = self.configureCollectionCell(cell, data: data)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.transferIndex(indexPath.row)
        let data = self.dataArray![index]
        if self.didSelectClosure != nil {
            self.didSelectClosure!(index,data);
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.resetTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.dataArray == nil {
            return
        }
        
        var index:Float
        switch self.scrollDirection {
        case .horizontal:
            index = Float(scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width)
        case .vertical:
            index = Float(scrollView.contentOffset.y * 1.0 / scrollView.frame.size.height)
        }
        
        if index < 0.25 {
            self.collectionView.scrollToItem(at: IndexPath(item: self.dataArray!.count, section: 0), at: [.top,.left], animated: false)
        }else if index >= Float(self.dataArray!.count+1) {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top,.left], animated: false)
        }
        
        let page = self.transferIndex(Int(index))
        
        scrollToPage(page)
    }
    
    func scrollToPage(_ page:Int){}
    
    //MARK:timer
    func resetTimer() {
        self.timer?.invalidate()
        
        if(self.autoScrollInterval<=0 || self.dataArray == nil || self.dataArray!.count<2) {
            return
        }
        
        var timeInterval:Double = self.autoScrollInterval
        if timeInterval<0.5 {
            timeInterval = 0.5
        }
        
        self.timer = Timer.cy_scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [unowned self] (cTimer) in
            
            guard let currentIp:IndexPath = self.collectionView.indexPathsForVisibleItems.first else{ return }
            
            if currentIp.row+1 >= self.dataArray!.count+2{return}
            
            let nextIndexPath = IndexPath(item: currentIp.row+1, section: 0)
            self.collectionView.scrollToItem(at: nextIndexPath, at: [.top,.left], animated: true)
        })
        
        RunLoop.current.add(self.timer!, forMode: .commonModes)
        
    }
    
    //MARK:reload method
    func refresh() {
        self.collectionView.reloadData()
        self.resetTimer()
        //it's unable to scroll before the collectionview is shown
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top,.left], animated: false)
        }
    }
    
    private func transferIndex(_ index:Int) -> Int {
        if self.dataArray==nil||self.dataArray!.count<=1 {
            return 0;
        }
        if index == 0 {
            return self.dataArray!.count-1;
        }else if index == self.dataArray!.count+1 {
            return 0;
        }
        
        return index-1;
    }

}
