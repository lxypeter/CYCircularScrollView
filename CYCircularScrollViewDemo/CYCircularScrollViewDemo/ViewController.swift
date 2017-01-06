//
//  ViewController.swift
//  CYCircularScrollViewDemo
//
//  Created by Peter Lee on 2017/1/5.
//  Copyright © 2017年 CY.Lee. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width

class ViewController: UIViewController {
    
    //MARK: property
    var announceArray:Array<Any> = [Announcement(title:"First Announcement",time:"2017-01-01"),
                                    Announcement(title:"Second Announcement",time:"2017-01-02"),
                                    Announcement(title:"Third Announcement",time:"2017-01-03")]
    
    //MARK: life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
    }
    
    func configureSubviews() {
        
        self.view.backgroundColor = UIColor.lightGray
        
        //CYPicBannerScrollView
        let imageArray = [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!]
        let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                               images:imageArray ) { (index, data) in
            //click event
        }
        
//        let urlArray = ["www","www","www"]
//        let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
//                                               urlStrings: urlArray,
//                                               placeholder: UIImage(named: "pic_placeholder")) { (index, data) in
//            
//        }
        
//        let announceArray = [Announcement(title:"First Announcement",time:"2017-01-01",image:"p1"),
//                            Announcement(title:"Second Announcement",time:"2017-01-02",image:"p2"),
//                            Announcement(title:"Third Announcement",time:"2017-01-03",image:"p3")]
//        let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
//                                               models: announceArray,
//                                               placeholder: UIImage(named: "pic_placeholder"),
//                                               modelImage: { (model) -> (CYImageResult) in
//            let announcement = model as! Announcement
//            return CYImageResult(data: UIImage(named: model.image)!, type: .image)
//        }) { (index, data) in
//            //click event
//        }
        
        bannerView.autoScrollInterval = 3.0
        
        //define the UIPageControl style as you like
        bannerView.pageControlPosition = .right
        bannerView.pageControl.backgroundColor = UIColor(displayP3Red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.8)
        bannerView.pageControl.layer.cornerRadius = 8
        
        self.view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(525/1125*ScreenWidth)
        }
        
        
        //Custom subclass sample
        let annouceScrollView:CYAnnounceScrollView = CYAnnounceScrollView(frame: CGRect.zero, datas: self.announceArray) { (index, data) in
//            if let announcement = data as? Announcement {
//
//            }
        }
        self.view.addSubview(annouceScrollView)
        
        annouceScrollView.autoScrollInterval = 3.0
        annouceScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(bannerView.snp.bottom).offset(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(64)
        }
    }

}

