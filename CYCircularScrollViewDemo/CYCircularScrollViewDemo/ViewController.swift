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
        let bannerView:CYPicBannerScrollView = CYPicBannerScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), images: [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!]) { (index, data) in
            
        }
        
        //define the UIPageControl style as you like
        bannerView.pageControlPosition = .right
//        bannerView.pageControlOffset = UIOffset(horizontal: -10, vertical: -5)
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
        
        annouceScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(bannerView.snp.bottom).offset(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(64)
        }
    }

}

