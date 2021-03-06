//
//  ViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/10.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import Photos
import QBImagePickerController
import MobileCoreServices
import AVFoundation

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate, AdShowable {

    @IBOutlet weak var FixedSpace1: UIBarButtonItem!
    @IBOutlet weak var FixedSpace2: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var mytext = ""
    
    var albumName: String?
    var selectedIndex: Int?
    
    // prepare variables for document folder
    let fileManager = FileManager.default
    var dirAlbum: String = ""
    var dirThumbnail: String = ""
    var contentNumber: Int = 0
    
    let thumbnailSize: CGFloat = 150
    let savePhotoHeight: CGFloat = 1024
    let savePhotoWidth: CGFloat = 1024
    
    var cellSize: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title on navigation bar
        self.title = albumName
        // save current album path in document directry
        var pathToAlbum: String = ""
        var pathToThumbnail: String = ""
        if MyVariables.fakeFlag == false {
            pathToAlbum = "/trueAlbum/" + self.albumName!
            pathToThumbnail = "/trueThumbnail/" + self.albumName!
        } else {
            pathToAlbum = "/fakeAlbum/" + self.albumName!
            pathToThumbnail = "/fakeThumbnail/" + self.albumName!
        }

        dirAlbum = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToAlbum) as String
        dirThumbnail = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToThumbnail) as String
        
        self.layoutCollectionView()
        cellSize = self.setCellSize()
        
        //self.view.addSubview(getAdViewOverTabBar(tabBarHeight: self.toolBar.frame.height))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.setNeedsDisplay()
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        
        
    }
    // 向きが変わったらframeをセットしなおして再描画
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutCollectionView()
        self.layoutTabBar()
        cellSize = self.setCellSize()
        collectionView.setNeedsDisplay()
        collectionView.reloadData()
    }

    
    func layoutCollectionView() {
        collectionView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        collectionView.center.x = view.center.x
        collectionView.center.y = view.center.y
    }
    
    func layoutTabBar() {
        let displayWidth = (view.frame.width - 44 * 2)/3
        self.FixedSpace1.width = displayWidth
        self.FixedSpace2.width = displayWidth
    }
    
    func setCellSize() -> CGFloat {
        if UIDevice.current.orientation == .portrait {
            cellSize = self.view.frame.size.width/4 - 2
        } else if UIDevice.current.orientation == .landscapeLeft {
            cellSize = self.view.frame.size.width/7 - 2
        } else if UIDevice.current.orientation == .landscapeRight {
            cellSize = self.view.frame.size.width/7 - 2
        } else {
            cellSize = self.view.frame.size.width/4 - 2
        }
        
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // define myCell from Identifier in storyboard
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoViewCell
        // UICollectionView heritates UIView, whose method is contentView
        let localPath = try? fileManager.contentsOfDirectory(atPath: dirThumbnail)[indexPath.row]
        let imagePath = dirThumbnail.stringByAppendingPathComponent1(path: localPath!)
        // Fethch image from Document/collection/<AlbumName>
        let image = UIImage(contentsOfFile: imagePath)!
        myCell.photoImageView.image = image
        
        // Adjust cell size
        let rect:CGRect = CGRect(x:0, y:0, width: cellSize, height: cellSize)
        myCell.photoImageView.frame = rect
        myCell.photoImageView.center = CGPoint(x: cellSize/2, y:cellSize/2)
 
        return myCell
        
    }
    
    // Adjust the size of each photo
    // Can be activated with UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: cellSize, height: cellSize)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Number of section is always 1 in this app
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of items in the section
        // number of contents in this album
        try? contentNumber = fileManager.contentsOfDirectory(atPath: dirThumbnail).count

        return contentNumber
    }
    
    // When myCell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        performSegue(withIdentifier: "toSubPhotoViewController", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "toSubPhotoViewController"){
            let subVC: SubPhotoViewController = (segue.destination as? SubPhotoViewController)!
            // Set selectedImage to SubPhotoViewController

            subVC.selectedIndex = selectedIndex
            subVC.albumName = albumName
        }
    }

    
    // Called when PhotoLibrary button is pressed
    // Use QUImagePickerController
    func pickPluralImageFromLibrary(){
        // Define instance of QBImagePickerController
        let picker = QBImagePickerController()
        
        // Set parameters for the use
        picker.allowsMultipleSelection = true
        picker.showsNumberOfSelectedAssets = true
        
        picker.delegate = self
        
        // show next UIView
        self.present(picker, animated: true, completion: nil)
        
    }
    
    // Called when Camera button on bottom tab bar is pressed
    func pickImageFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            // Define ViewController to show the image from photo library
            let controller = UIImagePickerController()
            
            // A strange cast
            controller.delegate = self
            
            // See which source type to show in the defined ViewController
            controller.sourceType  = UIImagePickerControllerSourceType.camera
            // Movie and Photo Setting
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: controller.sourceType) {
                
                controller.mediaTypes = availableMediaTypes
                controller.videoQuality = UIImagePickerControllerQualityType.typeHigh
                controller.videoMaximumDuration = TimeInterval(300)
                controller.allowsEditing = false
                
                
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        // For controlling photo path enregistered in the same time
        var count: Int = 0
   
        for asset in assets {
            // semaphore must declared each time!!!
            let semaphore = DispatchSemaphore(value: 0)
            let myasset = asset as! PHAsset
            if myasset.mediaType == PHAssetMediaType.image {

                
                    let thumbnai: UIImage = self.getAssetThumbnail(asset: myasset)
                    //File name: CurrentTime.png
             
                    if let photoData = UIImagePNGRepresentation(thumbnai){
                        let photoName = "\(NSDate().description + String(count)).png"
                        let path = self.dirAlbum.stringByAppendingPathComponent1(path: photoName)
                
                        do {
                            try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                            semaphore.signal()
                        } catch {
                            print("error while writing to path:\(path)")
                        }
                    }
                    semaphore.wait()
                
                    let cropImage: UIImage = thumbnai.TrimingUIImage()
                    let resizedImage = cropImage.ResizeUIImage(width: self.thumbnailSize, height: self.thumbnailSize)
                    if let photoDataThumbnail = UIImagePNGRepresentation(resizedImage!){
                        let photoNameThumbnail = "\(NSDate().description + String(count)).png"
                        let pathThumbnail = self.dirThumbnail.stringByAppendingPathComponent1(path: photoNameThumbnail)
                        
                        do {
                            try photoDataThumbnail.write(to: URL(fileURLWithPath: pathThumbnail), options: .atomic)
                            semaphore.signal()
                        } catch {
                            print("error while writing to path:\(pathThumbnail)")
                        }
                        
                    }
                    semaphore.wait()

            }  else if myasset.mediaType == PHAssetMediaType.video {

                PHImageManager.default().requestAVAsset(forVideo: myasset, options: nil, resultHandler:
                    {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                        
                        let tempasset = avAsset as! AVURLAsset
                        
                        let videoData = NSData(contentsOf: tempasset.url)
                        let movieName = "\(NSDate().description + String(count)).mov"
                        let path = self.dirAlbum.stringByAppendingPathComponent1(path: movieName)
                        
                        videoData?.write(toFile: path, atomically: true)
                        
                        
                        if let photoDataThumbnail = UIImagePNGRepresentation(self.getMovieThumbnailByPath(path: path)){
                            let photoNameThumbnail = "\(NSDate().description + String(count)).png"
                            let pathThumbnail = self.dirThumbnail.stringByAppendingPathComponent1(path: photoNameThumbnail)
                            
                            do {
                                try photoDataThumbnail.write(to: URL(fileURLWithPath: pathThumbnail), options: .atomic)
                                semaphore.signal()
                            } catch {
                                print("error while writing to path:\(pathThumbnail)")
                            }
                            
                        }
                        semaphore.signal()
                        
                })

                semaphore.wait()
                print("escaped")
                
            }
            count += 1
            print("photocount: \(count)")

            }
        
            self.collectionView.setNeedsDisplay()
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.dismiss(animated: true, completion: nil)
        
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if picker.sourceType == .camera
        {
            let mediaType: String = info[UIImagePickerControllerMediaType] as! String
            if mediaType == "public.image" {
                if let tookImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage{
                    // This line is to treat the rotation to portrait
                    let rotatedImage = tookImage.ResizeUIImage(width: tookImage.size.width, height: tookImage.size.height)
                    if let photoData = UIImagePNGRepresentation(rotatedImage!){
                        
                        //保存ディレクトリ: Document/<AlbumName> is set at vidwDidRoad()
                        if !fileManager.fileExists(atPath: dirAlbum) {} else{
                            print("unable to find designated folder")
                        }
                        
                        
                        
                        
                        //File name: CurrentTime.png
                        let photoName = "\(NSDate().description).png"
                        print(photoName)
                        let path = dirAlbum.stringByAppendingPathComponent1(path: photoName)
                        
                        
                        // Save
                        do{
                         try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                        } catch {
                            print("error while writing to path:\(path)")
                        }
                        
                    }
                    
                    // Prepare small image data for Thumbnail view
                    // To prepare a thumbnail with a good frame, first triming and then smallen
                    let cropImage: UIImage = tookImage.TrimingUIImage()
                    let resizedImage = cropImage.ResizeUIImage(width: 150, height: 150)
                    
                    if let photoData = UIImagePNGRepresentation(resizedImage!){
                        
                        //保存ディレクトリ: Document/<AlbumName> is set at vidwDidRoad()
                        if !fileManager.fileExists(atPath: dirThumbnail) {} else{
                            print("unable to find designated folder")
                        }
                        
                        //File name: CurrentTime.png
                        let photoName = "\(NSDate().description).png"
                        print(photoName)
                        let path = dirThumbnail.stringByAppendingPathComponent1(path: photoName)
                        
                        
                        // Save
                        do{
                            try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                        } catch {
                            print("error while writing to path:\(path)")
                        }
                        
                    }

                }
            

            }else if mediaType == "public.movie"{
                if !fileManager.fileExists(atPath: dirAlbum) {} else{
                    print("unable to find designated folder")
                }
                
                let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                let videoData = NSData(contentsOf: videoURL)
                let movieName = "\(NSDate().description).mov"
                let path = dirAlbum.stringByAppendingPathComponent1(path: movieName)
                
                videoData?.write(toFile: path, atomically: false)
                
                if let photoData = UIImagePNGRepresentation(self.getMovieThumbnailByPath(path: path)){
                    
                    //保存ディレクトリ: Document/<AlbumName> is set at vidwDidRoad()
                    if !fileManager.fileExists(atPath: dirThumbnail) {} else{
                        print("unable to find designated folder")
                    }
                    
                    //File name: CurrentTime.png
                    let photoName = "\(NSDate().description).png"
                    print(photoName)
                    let path = dirThumbnail.stringByAppendingPathComponent1(path: photoName)
                    
                    
                    // Save
                    do{
                        try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                    } catch {
                        print("error while writing to path:\(path)")
                    }
                    
                }
            }

        }
        
        collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapAddButton(_ sender: Any) {
        // Do any additional setup after loading the view, typically from a nib.
        libraryRequestAuthorization()
        pickPluralImageFromLibrary()
    }

    @IBAction func tapCamerButton(_ sender: Any) {
        cameraSelected()
        microSelected()
        pickImageFromCamera()
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let semaphore = DispatchSemaphore(value: 0)
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: self.savePhotoWidth, height: self.savePhotoHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
            semaphore.signal()
        })
        semaphore.wait()
        return thumbnail
    }
    
    func getMovieThumbnailByPHAsset(asset: PHAsset, path: String) -> UIImage{

        let filePath: URL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: filePath, options: nil)
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: self.savePhotoWidth, height: self.savePhotoHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!

        })
        
        let myImage: UIImage = self.AddTimeMovieThumbnail(thumbnail: thumbnail, asset: avAsset)
        
        return myImage

    }

    func getMovieThumbnailByPath(path: String) -> UIImage{
        print("start getmovie Thumbnailbypath")
         let filePath: URL = URL(fileURLWithPath: path)
         let avAsset = AVURLAsset(url: filePath, options: nil)
         let imgGenerator = AVAssetImageGenerator(asset: avAsset)
         imgGenerator.appliesPreferredTrackTransform = true
         let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
         let thumbnail = UIImage(cgImage: cgImage!)
        
        let myImage: UIImage = self.AddTimeMovieThumbnail(thumbnail: thumbnail, asset: avAsset)
        
        return myImage
        
    }

    func AddTimeMovieThumbnail(thumbnail: UIImage, asset: AVAsset) -> UIImage{
         print("start of addtimemoviethmbnail")
        // Triming for a prepared frame and then Smallen the image
        let cropImage: UIImage = thumbnail.TrimingUIImage()
        let resizedImage = cropImage.ResizeUIImage(width: self.thumbnailSize, height: self.thumbnailSize)
        print("resize image of addtimemoviethmbnail")
        let imageWidth = resizedImage!.size.width
        let imageHeight = resizedImage!.size.height
        
        let rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        // Start Context! Deploy your canvas on the image
        UIGraphicsBeginImageContext(resizedImage!.size)
        
        //Rendering with drawInRect method
        resizedImage?.draw(in: rect)
        
        // Text canvas
        let textRect = CGRect(x: imageWidth*0.55, y: imageHeight*0.75, width: imageWidth*0.4, height: imageHeight*0.3)
        
        let font = UIFont.systemFont(ofSize: 20)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        
        let rawTime = CMTimeGetSeconds(asset.duration)
        let time: Int = Int(rawTime)
        let seconds: Int = time % 60
        let minutes: Int = (time - seconds)/60
        var textSeconds: String = ""
        if seconds < 10 {
            textSeconds = "0" + String(seconds)
        } else {
            textSeconds = String(seconds)
        }
        let text = "\(minutes):" + textSeconds
        
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: textStyle
        ]
        print("rendering text")
        // テキストをdrawInRectメソッドでレンダリング
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Context に描画された画像を新しく設定
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Context 終了
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
    func libraryRequestAuthorization() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let wself = self else {
                return
            }
            switch status {
            case .authorized:
                return
            case .denied:
                wself.showDeniedAlert()
            case .notDetermined:
                print("NotDetermined")
            case .restricted:
                print("Restricted")
            }
        })
    }
    
    func showDeniedAlert() {
        let alert: UIAlertController = UIAlertController(title: "エラー",
                                                         message: "「写真」へのアクセスが拒否されています。設定より変更してください。",
                                                         preferredStyle: .alert)
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                  style: .cancel,
                                                  handler: nil)
        let ok: UIAlertAction = UIAlertAction(title: "設定画面へ",
                                              style: .default,
                                              handler: { [weak self] (action) -> Void in
                                                guard let wself = self else {
                                                    return
                                                }
                                                wself.transitionToSettingsApplition()
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func transitionToSettingsApplition() {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                
            }
        }
    }
    
    func cameraSelected() {
        // First we check if the device has a camera (otherwise will crash in Simulator - also, some iPod touch models do not have a camera).
        let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        if (deviceHasCamera) {
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            switch authStatus {
            case .authorized: break;
            case .denied: alertPromptToAllowCameraAccessViaSettings()
            case .notDetermined: permissionPrimeCameraAccess()
            default: permissionPrimeCameraAccess()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "\"<Your App>\" Would Like To Access the Camera", message: "Please grant permission to use the Camera.", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel))
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func permissionPrimeCameraAccess() {
        let alert = UIAlertController( title: "\"<Your App>\" Would Like To Access the Camera", message: "<Your App> would like to access your Camera.", preferredStyle: .alert )
        let allowAction = UIAlertAction(title: "Allow", style: .default)
        if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraSelected() // try again
                }
            })
        }
        
        alert.addAction(allowAction)
        let declineAction = UIAlertAction(title: "Not Now", style: .cancel)
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }
    
    func microSelected() {
        // First we check if the device has a camera (otherwise will crash in Simulator - also, some iPod touch models do not have a camera).
        let deviceHasMicro = UIImagePickerController.isSourceTypeAvailable(.camera)
        if (deviceHasMicro) {
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
            switch authStatus {
            case .authorized: break;
            case .denied: alertPromptToAllowMicroAccessViaSettings();
            case .notDetermined: permissionPrimeMicroAccess()
            default: permissionPrimeMicroAccess()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertPromptToAllowMicroAccessViaSettings() {
        let alert = UIAlertController(title: "\"<Your App>\" Would Like To Access the Camera", message: "user can use video.", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel))
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        
        present(alert, animated: true, completion: nil)
    }
    
    func permissionPrimeMicroAccess() {
        let alert = UIAlertController( title: "\"<Your App>\" Would Like To Access the micro", message: "user can use video", preferredStyle: .alert )
        let allowAction = UIAlertAction(title: "Allow", style: .default)
        if AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio).count > 0 {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraSelected() // try again
                }
            })
        }
        
        alert.addAction(allowAction)
        let declineAction = UIAlertAction(title: "Not Now", style: .cancel)
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }
}


extension String {
    func stringByAppendingPathComponent1(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}

extension UIImage{
    
    // Resizeするクラスメソッド.
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // コンテキストに自身に設定された画像を描画する.
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func TrimingUIImage() -> UIImage! {
        
        let imageHeight = self.size.height
        let imageWidth = self.size.width
        let imageFrame = (imageHeight > imageWidth) ? imageWidth : imageHeight
        var displacementX: CGFloat = 0
        var displacementY: CGFloat = 0
        
        if imageHeight < imageWidth {
            displacementX = (imageWidth - imageHeight)/2
        } else {
            displacementY = (imageHeight - imageWidth)/2
        }
        
        let cropCGImageRef = self.cgImage!.cropping(to: CGRect(x: displacementX, y: displacementY, width: imageFrame, height: imageFrame))
        let trimmedImage = UIImage(cgImage: cropCGImageRef!)
        
        return trimmedImage
    }

}
