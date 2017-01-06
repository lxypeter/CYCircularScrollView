//
//  CYAnnounceScrollView.swift
//  SDClientsPlatformSwift
//
//  Created by Peter Lee on 2016/12/21.
//  Copyright © 2016年 ZTESoft. All rights reserved.
//

import UIKit
import SnapKit

class Announcement {
    
    var title:String
    var time:String
    
    init(title:String, time:String) {
        self.title = title
        self.time = time
    }
    
}

class CYAnnounceCell: UICollectionViewCell {
    
    var titleLabel:UILabel?
    var subtitleLabel:UILabel?
    var rightIconImageView:UIImageView?
    var announcement:Announcement? {
        didSet{
            self.subtitleLabel?.text = self.announcement?.time;
            self.titleLabel?.text = self.announcement?.title;
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let rightIconImageView = UIImageView()
        rightIconImageView.image = UIImage(named: "list_ico_tosub")
        self.contentView.addSubview(rightIconImageView)
        rightIconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(25)
            make.height.equalTo(25);
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-10)
        }
        self.rightIconImageView = rightIconImageView
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(-8)
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(rightIconImageView.snp.left).offset(-5)
        }
        self.titleLabel = titleLabel;
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5);
            make.left.equalTo(self.snp.left).offset(16);
            make.right.equalTo(rightIconImageView.snp.left).offset(-5)
        }
        self.subtitleLabel = subtitleLabel;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CYAnnounceScrollView : CYCircularScrollView{
    
    override var cellClass:UICollectionViewCell.Type {
        return CYAnnounceCell.self
    }
    
    override var scrollDirection:CYScrollDirection {
        return .vertical
    }
    
    override var isScrollEnabled:Bool {
        return false
    }
    
    override func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell {
        
        let announceCell = cell as! CYAnnounceCell
        
        if let announcement:Announcement = data as? Announcement{
            announceCell.announcement = announcement
        }
        
        return announceCell
    }

}
