//
//  CYPicBannerScrollView.swift
//  SDClientsPlatformSwift
//
//  Created by Peter Lee on 2016/12/22.
//  Copyright © 2016年 ZTESoft. All rights reserved.
//

import UIKit
import Kingfisher

enum CYPageControlPosition{
    case center
    case right
    case left
}

enum CYImageDataType{
    case image
    case url
    case model
}

enum CYImageType{
    case image
    case urlString
}

struct CYImageResult{
    var data:Any
    var type:CYImageType
    
    init(data:Any, type:CYImageType) {
        self.data = data
        self.type = type
    }
}

class CYPicBannerCell : UICollectionViewCell{
    var imageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView()
        self.contentView.addSubview(imageView)
        imageView.frame = self.contentView.bounds
        self.imageView = imageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CYPicBannerScrollView : CYCircularScrollView {
    
    //MARK: property
    override var cellClass:UICollectionViewCell.Type {
        return CYPicBannerCell.self
    }
    
    override var dataArray:[Any]? {
        didSet{
            self.updatePageControl()
        }
    }
    
    var imageDataType:CYImageDataType = .image {
        didSet{
            self.refresh()
        }
    }
    
    var placeholderImage:UIImage?
    
    lazy var pageControl:UIPageControl = {
        let pageControl:UIPageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(pageControl)
        return pageControl
    }()
    
    var pageControlPosition:CYPageControlPosition = .center{
        didSet{
            self.updatePageControl()
        }
    }
    
    var pageControlOffset:UIOffset = UIOffset.zero{
        didSet{
            self.updatePageControl()
        }
    }
    
    var modelImageClosure:((Any)->(CYImageResult))? {
        didSet{
            self.refresh()
        }
    }
    
    convenience init(frame:CGRect, images:[Any]?, didSelected:((Int,Any)->())?) {
        self.init(frame: frame)
        dataArray = images
        didSelectClosure = didSelected
        imageDataType = .image
        self.refresh()
    }
    
    convenience init(frame:CGRect, urlStrings:[Any]?, placeholder:UIImage?, didSelected:((Int,Any)->())?) {
        self.init(frame: frame)
        dataArray = urlStrings
        didSelectClosure = didSelected
        imageDataType = .url
        placeholderImage = placeholder
        self.refresh()
    }

    convenience init(frame:CGRect, models:[Any]?, placeholder:UIImage?, modelImage:@escaping (Any)->(CYImageResult), didSelected:((Int,Any)->())?) {
        self.init(frame: frame)
        dataArray = models
        didSelectClosure = didSelected
        imageDataType = .model
        modelImageClosure = modelImage
        placeholderImage = placeholder
        self.refresh()
    }
    
    //MARK: page control setting
    func updatePageControl() {
        
        if self.dataArray == nil || self.dataArray!.count <= 1 {
            self.pageControl.isHidden = true
            return
        }

        self.pageControl.isHidden = false
        self.pageControl.numberOfPages = self.dataArray!.count
        
        let pageControlWidth:Double = Double(self.dataArray!.count) * 15
        let pageControlHeight:Double = 16
        
        //Use SnapKit is much better, but I don't want to import too many frameworks...
        self.removePageControlAutoLayout()
        let widthConst = NSLayoutConstraint(item: self.pageControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(pageControlWidth))
        let hightConst = NSLayoutConstraint(item: self.pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(pageControlHeight))
        self.pageControl.addConstraints([widthConst,hightConst])
        
        switch (self.pageControlPosition) {
        case .right:
            let XConst:NSLayoutConstraint = NSLayoutConstraint(item: self.pageControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15+pageControlOffset.horizontal)
            self.addConstraint(XConst)
        case .left:
            let XConst:NSLayoutConstraint = NSLayoutConstraint(item: self.pageControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15+pageControlOffset.horizontal)
            self.addConstraint(XConst)
        default:
            let XConst:NSLayoutConstraint = NSLayoutConstraint(item: self.pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: pageControlOffset.horizontal)
            self.addConstraint(XConst)
        }
        
        let YConst:NSLayoutConstraint = NSLayoutConstraint(item: self.pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: pageControlOffset.vertical-10)
        self.addConstraint(YConst)
    }
    
    private func removePageControlAutoLayout(){
        self.pageControl.removeConstraints(self.pageControl.constraints)
        for constraint in self.constraints{
            if constraint.firstItem === self.pageControl{
                self.removeConstraint(constraint)
            }
        }
    }
    
    //MARK:override method
    override func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell{
        let bannerCell = cell as! CYPicBannerCell
        
        switch self.imageDataType {
            case .model:
                if self.modelImageClosure != nil {
                    let result:CYImageResult = self.modelImageClosure!(data)
                    switch result.type {
                        case .image:
                            if let image = result.data as? UIImage{
                                bannerCell.imageView?.image = image
                            }
                            bannerCell.imageView?.image = result.data as? UIImage
                        case .urlString:
                            if let urlString = result.data as? String{
                                let url:URL = URL(string: urlString)!
                                bannerCell.imageView?.kf.setImage(with: url, placeholder: self.placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
                            }
                    }
                }
            case .url:
                if let urlString = data as? String{
                    let url:URL = URL(string: urlString)!
                    bannerCell.imageView?.kf.setImage(with: url, placeholder: self.placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
                }
            default:
                if let image = data as? UIImage{
                    bannerCell.imageView?.image = image
                }
        }
        
        return bannerCell
    }
    
    override func scrollToPage(_ page: Int) {
        self.pageControl.currentPage = page
    }

}
