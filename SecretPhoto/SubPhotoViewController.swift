//
//  SubPhotoViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/10.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import Photos

class SubPhotoViewController: UIViewController, UIPageViewControllerDataSource, AdShowable {
    
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var FixedSpace1: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var selectedPhoto: UIImage?
    var selectedIndex: Int?
    var currentIndex: Int?
    var albumName: String?
    
    let fileManager = FileManager.default
    var dirAlbum: String = ""
    var dirThumbnail: String = ""
    var contentNumber: Int = 0
    var dataInstance: DataViewController?

    var height: CGFloat?
    var width: CGFloat?
    
    // Store the instance of UIPageViewController embedded into ContainerView
    var pageViewController: UIPageViewController?
    
    // Store the ViewController to showed with paging
    var dataArray = [DataViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewFrame()
        layoutTabBar()
        
        dataArray = [DataViewController]()

        if currentIndex == nil {
         currentIndex = selectedIndex!
        }
        
        print(currentIndex!)
        
        var pathToAlbum: String = ""
        var pathToThumbnail: String = ""
        if MyVariables.fakeFlag == false {
            pathToAlbum     = "/trueAlbum/" + self.albumName!
            pathToThumbnail = "/trueThumbnail/" + self.albumName!
        } else {
            pathToAlbum     = "/fakeAlbum/" + self.albumName!
            pathToThumbnail = "/fakeThumbnail/" + self.albumName!
        }
        
        dirAlbum = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToAlbum) as String
        dirThumbnail = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToThumbnail) as String
        
        try? contentNumber = fileManager.contentsOfDirectory(atPath: dirAlbum).count
        
        // Set Navigation bar title
        self.title = " \(currentIndex! + 1) of \(contentNumber)"
        // Set Navigation bar translucent
        self.navigationController!.navigationBar.alpha  = 0.7
        self.navigationController!.navigationBar.isTranslucent = true
        
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
            let instance: DataViewController = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
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
        /*
        // ダブルタップ
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(SubPhotoViewController.tapDouble(sender:)))  //Swift3
        doubleTap.numberOfTapsRequired = 2
        photoView.addGestureRecognizer(doubleTap)
        */
        // シングルタップ
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SubPhotoViewController.tapSingle(sender:)))  //Swift3
        singleTap.numberOfTapsRequired = 1
        //singleTap.numberOfTouchesRequired = 2  //こう書くと2本指じゃないとタップに反応しない
        
        //これを書かないとダブルタップ時にもシングルタップのアクションも実行される
        // singleTap.require(toFail: doubleTap)  //Swift3
        
        view.addGestureRecognizer(singleTap)
        
        MyVariables.globalCurrentIndex = currentIndex
        
        //self.view.addSubview(getAdViewOverTabBar(tabBarHeight: self.toolBar.frame.height))

    }
   
    override func viewWillAppear(_ animated: Bool) {
                
        if MyVariables.globalCurrentIndex != currentIndex {
            pageViewController!.setViewControllers([dataArray[MyVariables.globalCurrentIndex!]], direction: .forward, animated: false, completion: nil)
        }
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setViewFrame()
        layoutTabBar()
    }
    
    // 逆方向にページ送りした時に呼ばれるメソッド
    // No Going Back for this Calendar
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = dataArray.index(of: viewController as! DataViewController), index > 0  else {

            // Here is called at the first of contents in the album
            currentIndex = dataArray.index(of: viewController as! DataViewController)
            self.title = " \(1) of \(contentNumber)"
            return nil
            
        }

        currentIndex = index

        MyVariables.globalCurrentIndex = currentIndex

        // Set Navigation bar title
        // I dont understand why index + 1 but it works as should be
        self.title = " \(index + 1) of \(contentNumber)"
        
        return dataArray[index - 1]
    }
    
    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = dataArray.index(of: viewController as! DataViewController), index < dataArray.count - 1  else {

            // Here is called at the last of contents in the album
            currentIndex = dataArray.index(of: viewController as! DataViewController)
            self.title = " \(dataArray.count) of \(contentNumber)"
            return nil
        
        }

        currentIndex = index

        MyVariables.globalCurrentIndex = currentIndex
        
        // Set Navigation bar title
        self.title = " \(index + 1) of \(contentNumber)"

        return dataArray[index + 1]
    }

    @IBAction func tapTrashButton(_ sender: Any) {
        deletePhoto(index: currentIndex!)
        dataArray.remove(at: currentIndex!)
        // Without this condition, an error occurs the deleted photo is the last one of the album
        // When loading DataViewController for the initial view
        if currentIndex! == contentNumber - 1 {
            currentIndex! -= 1
        }
        viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deletePhoto(index: Int){
        let localPath = try? fileManager.contentsOfDirectory(atPath: dirAlbum)[index]
        let localPathThumbnail = try? fileManager.contentsOfDirectory(atPath: dirThumbnail)[index]
        
        
        let photoPath = dirAlbum.stringByAppendingPathComponent1(path: localPath!)
        let photoPathThumbnail = dirThumbnail.stringByAppendingPathComponent1(path: localPathThumbnail!)
        
        do{
            try fileManager.removeItem(atPath: photoPath)
            try fileManager.removeItem(atPath: photoPathThumbnail)
        } catch {
            print("error occured while deleting photo \(photoPath)")
        }

        
        return
    }
    
    func getPageInstanceWithImage(index: Int) -> DataViewController{
        var localPath: String = ""
        
        // Create a instance of photo page view
        let temporalyInstance: DataViewController = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        // Get a path to the photo concerned
        try? localPath = fileManager.contentsOfDirectory(atPath: dirAlbum)[index]
        let initPhotoPath = dirAlbum.stringByAppendingPathComponent1(path: localPath)
        // Get a image
        let image: UIImage = UIImage(contentsOfFile: initPhotoPath)!
        temporalyInstance.image = image
        temporalyInstance.mediaType = "photo"
        return temporalyInstance
    }

    func getPageInstanceWithVideo(index: Int) -> DataViewController{
        // Create a instance of photo page view
        let temporalyInstance: DataViewController = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
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
        
        let nextView = self.storyboard!.instantiateViewController(withIdentifier: "SubSubPhotoViewController") as! SubSubPhotoViewController
        nextView.currentIndex = self.currentIndex
        nextView.albumName = self.albumName
        self.present(nextView, animated: false, completion: nil)
        
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
    
    func layoutTabBar() {
        let displayWidth = (view.frame.width - 50 )/2
        self.FixedSpace1.width = displayWidth
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }


}
