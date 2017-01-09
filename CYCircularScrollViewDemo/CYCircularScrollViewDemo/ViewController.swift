//
//  ViewController.swift
//  CYCircularScrollViewDemo
//
//  Created by Peter Lee on 2017/1/5.
//  Copyright © 2017年 CY.Lee. All rights reserved.
//

import UIKit
import SnapKit

let ScreenWidth = UIScreen.main.bounds.size.width

class SampleModel {
    let name:String
    let url:String
    
    init(name:String, url:String){
        self.name = name
        self.url = url
    }
}


class ViewController: UIViewController {
    
    //MARK: property
    var imageBannerView:CYPicBannerScrollView?
    var urlBannerView:CYPicBannerScrollView?
    var modelBannerView:CYPicBannerScrollView?
    var annouceScrollView:CYAnnounceScrollView?
    
    //MARK: life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
    }
    
    func configureSubviews() {
        
        self.view.backgroundColor = UIColor.lightGray
        
        //CYPicBannerScrollView
        self.configureImageBanner()
        self.configureUrlBanner()
        self.configureModelBanner()
        
        //Custom sample subclass
        self.configureCustomSample()

    }
    
    func configureImageBanner() {
        //local images
        let imageArray = [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!]
        let imageBannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                               images:imageArray ) { (index, data) in
            //click event
            print("imageBannerView : index - \(index) , data:\(data)")
        }
        
        //you can also set the property manually
//        imageBannerView.imageDataType = .image
//        imageBannerView.dataArray = imageArray
//        imageBannerView.didSelectClosure = { (index, data) in
//            //click event
//            print("imageBannerView : index - \(index) , data:\(data)")
//        }
        
        //define the UIPageControl style as you like
        imageBannerView.pageControlPosition = .right
        imageBannerView.pageControl.backgroundColor = UIColor(displayP3Red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.8)
        imageBannerView.pageControl.layer.cornerRadius = 8
        
        self.view.addSubview(imageBannerView)
        imageBannerView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(525/1125*ScreenWidth)
        }
        self.imageBannerView = imageBannerView
    }
    
    func configureUrlBanner() {
        //url
        let urlArray = ["http://i.imgur.com/7Ze2PdG.png","http://i.imgur.com/cAfBaMR.png","http://i.imgur.com/AimYvXb.png"]
        let urlBannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                                  urlStrings: urlArray,
                                                  placeholder: UIImage(named: "placeholder")) { (index, data) in
            //click event
            print("urlBannerView : index - \(index) , data:\(data)")
        }
        
        //you can also set the property manually
//        urlBannerView.imageDataType = .url
//        urlBannerView.dataArray = urlArray
//        urlBannerView.placeholderImage = UIImage(named: "placeholder")
//        urlBannerView.didSelectClosure = { (index, data) in
//            //click event
//        }
        
        self.view.addSubview(urlBannerView)
        urlBannerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageBannerView!.snp.bottom).offset(20)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(525/1125*ScreenWidth)
        }
        self.urlBannerView = urlBannerView
    }
    
    func configureModelBanner() {
        let modelArray = [SampleModel(name:"pic_1",url:"http://i.imgur.com/7Ze2PdG.png"),
                          SampleModel(name:"pic_2",url:"http://i.imgur.com/cAfBaMR.png"),
                          SampleModel(name:"pic_3",url:"http://i.imgur.com/AimYvXb.png")]
        let modelBannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                                    models: modelArray,
                                                    placeholder: UIImage(named: "placeholder"),
                                                    modelImage: { (model) -> (CYImageResult) in
            let sampleModel = model as! SampleModel
            return CYImageResult(data: sampleModel.url, type: .urlString)
        }) { (index, data) in
            //click event
            print("modelBannerView : index - \(index) , data:\(data)")
        }
        
        //you can also set the property manually
//        modelBannerView.imageDataType = .model
//        modelBannerView.dataArray = modelArray
//        modelBannerView.placeholderImage = UIImage(named: "placeholder")
//        modelBannerView.didSelectClosure = { (index, data) in
//            //click event
//            print("modelBannerView : index - \(index) , data:\(data)")
//        }
//        modelBannerView.modelImageClosure = { (model) -> (CYImageResult) in
//            let sampleModel = model as! SampleModel
//            return CYImageResult(data: sampleModel.url, type: .urlString)
//        }
        
        modelBannerView.pageControlPosition = .left
        
        self.view.addSubview(modelBannerView)
        modelBannerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.urlBannerView!.snp.bottom).offset(20)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(525/1125*ScreenWidth)
        }
        self.modelBannerView = modelBannerView
    }
    
    func configureCustomSample() {
        let announceArray:Array<Any> = [Announcement(title:"First Announcement",time:"2017-01-01"),
                                        Announcement(title:"Second Announcement",time:"2017-01-02"),
                                        Announcement(title:"Third Announcement",time:"2017-01-03")]
        
        //Custom sample subclass
        let annouceScrollView:CYAnnounceScrollView = CYAnnounceScrollView(frame: CGRect.zero, datas: announceArray) { (index, data) in
            //click event
            print("annouceScrollView : index - \(index) , data:\(data)")
        }
        self.view.addSubview(annouceScrollView)

        annouceScrollView.autoScrollInterval = 3.0
        annouceScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.modelBannerView!.snp.bottom).offset(20)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(64)
        }
    }

}

