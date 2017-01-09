# CYCircularScrollView
Used for picture banner or information display like announcement.

![alt tag](http://upload-images.jianshu.io/upload_images/1874636-b042607eec79025f.gif?imageMogr2/auto-orient/strip)

##Installation
###CocoaPods
```
pod 'CYCircularScrollView'
```
>CocoaPods 1.1.0+ is required.

###Manually
You can also import **CYCircularScrollView** to your project manually, but please notice that the picture banner **CYPicBannerScrollView** uses [Kingfisher](https://github.com/onevcat/Kingfisher) to load and cache the internet picture, so [Kingfisher](https://github.com/onevcat/Kingfisher) is required too. Of cource, you don't need to concern about this by the CocoaPods way.

##How to use

###The picture banner: CYPicBannerScrollView

####1.init
**CYPicBannerScrollView** supports 3 kinds of data source: `UIImage`,`Picture URL String` and `Model`. 3 convenice init methods are corresponding to them.
- UIImage

```swift
convenience init(frame:CGRect, images:[Any]?, didSelected:((Int,Any)->())?)
```
```swift
//e.g.
let imageArray = [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!]
let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                        images:imageArray ) { (index, data) in
    //click event
}
```
- Picture URL String

```swift
convenience init(frame:CGRect, urlStrings:[Any]?, placeholder:UIImage?, didSelected:((Int,Any)->())?)
```
```swift
//e.g.
let urlArray = ["www","www","www"]
let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                        urlStrings: urlArray,
                                        placeholder: UIImage(named: "pic_placeholder")) { (index, data) in
    //click event
}
```
- Model

```swift
convenience init(frame:CGRect, models:[Any]?, placeholder:UIImage?, modelImage:@escaping (Any)->(CYImageResult), didSelected:((Int,Any)->())?) 
```
```swift
//e.g.
let announceArray = [Announcement(title:"First Announcement",time:"2017-01-01",image:"p1"),
                    Announcement(title:"Second Announcement",time:"2017-01-02",image:"p2"),
                    Announcement(title:"Third Announcement",time:"2017-01-03",image:"p3")]
let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                        models: announceArray,
                                        placeholder: UIImage(named: "pic_placeholder"),
                                        modelImage: { (model) -> (CYImageResult) in
    let announcement = model as! Announcement
    return CYImageResult(data: UIImage(named: announcement.image)!, type: .image)
}) { (index, data) in
    //click event
}
```
For the source of Model, it's required to return a struct contains image data and type in the `modelImage` clousure. It supports type of UIImage like `CYImageResult(data: UIImage(named: model.image)!, type: .image)` or type of URL String like `CYImageResult(data: "http://image.com/image", type: .urlString)`.

####2. Customization
**CYPicBannerScrollView**support customization as below
```swift
bannerView.autoScrollInterval = 3.0 //interval of auto scroll,defalut is 5 sec

bannerView.pageControlPosition = .right //position of PageControl, default is center
bannerView.pageControlOffset = UIOffset(horizontal: -10, vertical: -5) //offset of PageControl,base on position of PageControl

//define the PageControl style as you wish
bannerView.pageControl.backgroundColor = UIColor(displayP3Red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.8)
bannerView.pageControl.layer.cornerRadius = 8
```

###Customized circle scorll view：CYCircularScrollView
You can create a customized circle scorll view in 4 steps.
- 1.inherit `CYCircularScrollView`
```swift
class CYAnnounceScrollView : CYCircularScrollView

```
- 2.override `var cellClass:UICollectionViewCell.Type` property

```swift
override var cellClass:UICollectionViewCell.Type {
    return CYAnnounceCell.self //type of your circle view, a subclass of UICollectionViewCell
}
```
- 3.override `func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell` method

```swift
override func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell {

    let announceCell = cell as! CYAnnounceCell

    if let announcement:Announcement = data as? Announcement{
        announceCell.announcement = announcement
    }

    return announceCell
}
```
- 4.override the optional property depend on your need

```swift
override var scrollDirection:CYScrollDirection {
    return .vertical//scroll direction，defalut is .horizontal
}

override var isScrollEnabled:Bool {
    return false//can be scrolled or not，defalut is true
}
```
After 4 steps, you can use you customized circle scorll view now~
```
let annouceScrollView = CYAnnounceScrollView(frame: CGRect.zero, datas: self.announceArray) { (index, data) in
    //click event
}
```
For more detail, you can find in Demo.



##安装
###CocoaPods
```
pod 'CYCircularScrollView'
```
>CocoaPods版本需要在1.1.0以上

###手动引入
你也可以手动将**CYCircularScrollView**拷贝到项目中，但注意项目中需要同时引入[Kingfisher](https://github.com/onevcat/Kingfisher),因为在轮播图控件**CYPicBannerScrollView**中直接使用了[Kingfisher](https://github.com/onevcat/Kingfisher)框架进行网络图片加载。

##如何使用

###轮播图控件：CYPicBannerScrollView

####1. 初始化
**CYPicBannerScrollView**支持三种类型的数据源：`UIImage`、`图片链接字符串`以及`数据模型(Model)`，与之对应的有3种初始化方法。
- UIImage类型

```swift
convenience init(frame:CGRect, images:[Any]?, didSelected:((Int,Any)->())?)
```
```swift
//e.g.
let imageArray = [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!]
let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                           images:imageArray ) { (index, data) in
    //click event
}
```
- 图片链接字符串

```swift
convenience init(frame:CGRect, urlStrings:[Any]?, placeholder:UIImage?, didSelected:((Int,Any)->())?)
```
```swift
//e.g.
let urlArray = ["www","www","www"]
let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                       urlStrings: urlArray,
                                       placeholder: UIImage(named: "pic_placeholder")) { (index, data) in
    //click event
}
```
- 数据模型(Model)

```swift
convenience init(frame:CGRect, models:[Any]?, placeholder:UIImage?, modelImage:@escaping (Any)->(CYImageResult), didSelected:((Int,Any)->())?) 
```
```swift
//e.g.
let announceArray = [Announcement(title:"First Announcement",time:"2017-01-01",image:"p1"),
                    Announcement(title:"Second Announcement",time:"2017-01-02",image:"p2"),
                    Announcement(title:"Third Announcement",time:"2017-01-03",image:"p3")]
let bannerView = CYPicBannerScrollView(frame: CGRect.zero,
                                       models: announceArray,
                                       placeholder: UIImage(named: "pic_placeholder"),
                                       modelImage: { (model) -> (CYImageResult) in
    let announcement = model as! Announcement
    return CYImageResult(data: UIImage(named: announcement.image)!, type: .image)
}) { (index, data) in
    //click event
}
```
对于对象模型类型的初始化，需要在`modelImage `闭包中根据数据模型返回图片数据源，支持直接返回UIImage如：`CYImageResult(data: UIImage(named: model.image)!, type: .image)`或链接字符串如：`CYImageResult(data: "http://image.com/image", type: .urlString)`

####2. 自定义样式
**CYPicBannerScrollView**支持以下形式的客制化
```swift
bannerView.autoScrollInterval = 3.0 //自动翻页间隔，默认为5秒

bannerView.pageControlPosition = .right //PageControl的位置，默认为center
bannerView.pageControlOffset = UIOffset(horizontal: -10, vertical: -5) //PageControl的基于位置的偏移量

//自定义PageControl的样式
bannerView.pageControl.backgroundColor = UIColor(displayP3Red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.8)
bannerView.pageControl.layer.cornerRadius = 8
```

###支持自定义视图的循环控件：CYCircularScrollView
要实现自定义视图循环展示只需要四步
- 1.继承 `CYCircularScrollView`
```swift
class CYAnnounceScrollView : CYCircularScrollView

```
- 2.覆写`var cellClass:UICollectionViewCell.Type`属性

```swift
override var cellClass:UICollectionViewCell.Type {
    return CYAnnounceCell.self //循环的视图类型，需为UICollectionViewCell子类
}
```
- 3.覆写`func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell`方法

```
override func configureCollectionCell(_ cell:UICollectionViewCell, data:Any) -> UICollectionViewCell {
        
    let announceCell = cell as! CYAnnounceCell
        
    if let announcement:Announcement = data as? Announcement{
        announceCell.announcement = announcement
    }
        
    return announceCell
}
```
- 4.根据需求覆写属性

```swift
override var scrollDirection:CYScrollDirection {
    return .vertical//滚动方向，默认为.horizontal
}
    
override var isScrollEnabled:Bool {
    return false//是否可以手动滚动，默认为true
}
```
此时你就能使用你自定义的视图控件了~
```
let annouceScrollView = CYAnnounceScrollView(frame: CGRect.zero, datas: self.announceArray) { (index, data) in
    //click event
}
```
更详尽的使用可以参照Demo。
