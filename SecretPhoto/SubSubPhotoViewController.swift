//
//  SubPhotoViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/10.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import Photos

class SubSubPhotoViewController: UIViewController, UIPageViewControllerDataSource, AdShowable {
    
    
    @IBOutlet weak var photoView: UIView!
    var selectedPhoto: UIImage?
    var selectedIndex: Int?
    var currentIndex: Int?
    var albumName: String?
    
    let fileManager = FileManager.default
    var dirAlbum: String = ""
    var contentNumber: Int = 0
    var dataInstance: SubDataViewController?
    
    var height: CGFloat?
    var width: CGFloat?
    
    // Store the instance of UIPageViewController embedded into ContainerView
    var pageViewController: UIPageViewController?
    
    // Store the ViewController to showed with paging
    var dataArray = [SubDataViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewFrame()
        
        dataArray = [SubDataViewController]()
        
        var pathToAlbum: String = ""
        if MyVariables.fakeFlag == false {
            pathToAlbum = "/trueAlbum/" + self.albumName!
        } else {
            pathToAlbum = "/fakeAlbum/" + self.albumName!
        }
        
        dirAlbum = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToAlbum) as String
        
        
        try? contentNumber = fileManager.contentsOfDirectory(atPath: dirAlbum).count
        // if any photo is in album folder, set into dataArray
        // if all photo are deleted from the album, return an empty dataviewcontroller
        if contentNumber > 0 {
            for index in 0...contentNumber - 1 {
                let pathString = try? fileManager.contentsOfDirectory(atPath: dirAlbum)[index]
                if (pathString!.range(of: ".png") != nil) {
                    
                    dataInstance = getPageInstanceWithImage(index: index)
                    dataArray.append(dataInstance!)
                    
                } else if (pathString!.range(of: ".mov") != nil){
                    dataInstance = getPageInstanceWithVideo(index: index)
                    dataArray.append(dataInstance!)
                }
            }
        } else {
            currentIndex! = 0
            let instance: SubDataViewController = storyboard?.instantiateViewController(withIdentifier: "SubDataViewController") as! SubDataViewController
            dataArray.append(instance)
        }
        
        // Get UIPageViewController embedded in ContainerView
        pageViewController = childViewControllers[0] as? UIPageViewController
        
        // Set Data Source
        pageViewController!.dataSource = self
        
        //Set ViewController for the initial view

        pageViewController!.setViewControllers([dataArray[currentIndex!]], direction: .forward, animated: false, completion: nil)
        
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        height = myBoundSize.height
        width = myBoundSize.width
        
        
        // ダブルタップ
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(SubDataViewController.tapDouble(gesture:)))  //Swift3
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SubSubPhotoViewController.tapSingle(sender:)))  //Swift3
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        //これを書かないとダブルタップ時にもシングルタップのアクションも実行される
        singleTap.require(toFail: doubleTap)  //Swift3
        
        print("currentIndex: \(currentIndex)")
        
        //self.view.addSubview(getAdView())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 端末の向きがかわったらNotificationを呼ばす設定.
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    
    // 端末の向きがかわったら呼び出される.
    func onOrientationChange(notification: Notification){
        
        self.setViewFrame()
        
    }

    
    // 逆方向にページ送りした時に呼ばれるメソッド
    // No Going Back for this Calendar
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = dataArray.index(of: viewController as! SubDataViewController), index > 0  else {
            currentIndex = dataArray.index(of: viewController as! SubDataViewController)
            return nil
        }
        
        currentIndex = index
        
        return dataArray[index - 1]
    }
    
    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = dataArray.index(of: viewController as! SubDataViewController), index < dataArray.count - 1  else {
            currentIndex = dataArray.index(of: viewController as! SubDataViewController)
            return nil
        }
        
        currentIndex = index
        
        return dataArray[index + 1]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getPageInstanceWithImage(index: Int) -> SubDataViewController{
        var localPath: String = ""
        
        // Create a instance of photo page view
        let temporalyInstance: SubDataViewController = storyboard?.instantiateViewController(withIdentifier: "SubDataViewController") as! SubDataViewController
        // Get a path to the photo concerned
        try? localPath = fileManager.contentsOfDirectory(atPath: dirAlbum)[index]
        let initPhotoPath = dirAlbum.stringByAppendingPathComponent1(path: localPath)
        // Get a image
        let image: UIImage = UIImage(contentsOfFile: initPhotoPath)!
        temporalyInstance.image = image
        temporalyInstance.mediaType = "photo"
        return temporalyInstance
    }
    
    func getPageInstanceWithVideo(index: Int) -> SubDataViewController{
        // Create a instance of photo page view
        let temporalyInstance: SubDataViewController = storyboard?.instantiateViewController(withIdentifier: "SubDataViewController") as! SubDataViewController
        // Get a path to the photo concerned
        let localPath = try? fileManager.contentsOfDirectory(atPath: dirAlbum)[index]
        let initVideoPath = dirAlbum.stringByAppendingPathComponent1(path: localPath!)
        // Get a video
        //let asset: AVAsset = AVURLAsset(url: URL(fileURLWithPath: initVideoPath))
        temporalyInstance.videoPath = initVideoPath
        temporalyInstance.mediaType = "video"
        return temporalyInstance
    }
    
    
    /// シングルタップ時に実行される
    func tapSingle(sender: UITapGestureRecognizer) {
        print("single")
        /*
        let nextView = self.storyboard!.instantiateViewController(withIdentifier: "SubPhotoViewController") as! SubPhotoViewController
        nextView.currentIndex = self.currentIndex
        nextView.albumName = self.albumName
        self.present(nextView, animated: true, completion: nil)
         */
        // 上のコードだと、戻った際にナビゲーションタブが吹き飛ぶ
        print("currentIndex: \(currentIndex)")
        print("globalIndex: \(MyVariables.globalCurrentIndex)")
        
        MyVariables.globalCurrentIndex = self.currentIndex
        self.dismiss(animated: false, completion: nil)
    }
    
    /// ダブルタップ時に実行される
    func tapDouble(sender: UITapGestureRecognizer) {
        print("Nothing")
    }
    
    
    func setViewFrame(){
        // Set display Size
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let displayHeight = myBoundSize.height
        let displayWidth = myBoundSize.width
        // set display frame
        photoView.frame = CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight)
        print(displayHeight)
        print(displayWidth)
        photoView.translatesAutoresizingMaskIntoConstraints = true

    }
    
}
