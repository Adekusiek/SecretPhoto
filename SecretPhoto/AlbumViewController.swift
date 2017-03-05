//
//  AlbumViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/11.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var text: String?
    var Albums: [String] = []
    var cellHeight: CGFloat = 0
    var cellWidth: CGFloat = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        if let savedAlbums = userDefaults.array(forKey: "Albums") as? [String]{
            Albums = savedAlbums
        }
        self.tableCellLayout()
        
        self.tableView.separatorStyle = .none
     }

    // 端末の向き変更を検知
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange(notification:)),name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // 向きが変わったらframeをセットしなおして再描画
    func onOrientationChange(notification: NSNotification){
        tableView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.tableCellLayout()
        tableView.setNeedsDisplay()
        tableView.reloadData()
    }
    
    func tableCellLayout() {
        // set cell height and width
        cellHeight = tableView.rowHeight
        cellWidth  = self.view.frame.width
        print(cellWidth)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return Albums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var numberOfContents: Int = 0
        // Path to Document/<Albumname>
        // Fetching image is faster with collection directry
        // Counting number of images and videos must be done in real data directly
        let fileManager = FileManager.default
        let pathToCollection = "/collection/" + Albums[indexPath.row]

        let dirCollection = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToCollection) as String
        do{
            try numberOfContents = fileManager.contentsOfDirectory(atPath: dirCollection).count
        } catch {
            numberOfContents = 0
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumViewCell
        cell.albumTitle.text = Albums[indexPath.row]

        if numberOfContents == 0 {
            cell.albumCount.text = "No Contents"

            // 表示する画像を設定する.
            let photoMarkImage = UIImage(named: "photoMark")
            // 画像をUIImageViewに設定する.
            cell.albumImage.image = photoMarkImage
            

        } else {
            cell.albumCount.text = String(numberOfContents)
            
            // UICollectionView heritates UIView, whose method is contentView
            let localPath = try? fileManager.contentsOfDirectory(atPath: dirCollection)[numberOfContents - 1]
            let imagePath = dirCollection.stringByAppendingPathComponent1(path: localPath!)
            // Fethch image from Document/collection/<AlbumName>
            let image = UIImage(contentsOfFile: imagePath)!
            cell.albumImage.image = image
            
            var photoBarImageView1: UIImageView!
            var photoBarImageView2: UIImageView!

            // UIImageViewを作成する.
            photoBarImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight * 0.7, height: cellHeight * 0.02))
            photoBarImageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight * 0.6, height: cellHeight * 0.02))
            
            // 表示する画像を設定する.
            let photoBarImage = UIImage(named: "PhotoBar")
            
            // 画像をUIImageViewに設定する.
            photoBarImageView1.image = photoBarImage
            photoBarImageView2.image = photoBarImage
            
            // 画像の表示する座標を指定する.
            photoBarImageView1.layer.position =  CGPoint(x: cellHeight * 0.7 , y: cellHeight * 0.08)
            photoBarImageView2.layer.position =  CGPoint(x: cellHeight * 0.7 , y: cellHeight * 0.05)
            
            // UIImageViewをViewに追加する.
            cell.addSubview(photoBarImageView1)
            cell.addSubview(photoBarImageView2)
            
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: Albums[indexPath.row]) as String
            
            let imageCount = fileNameCount(directoryPath: dir, extensionName: "png")
            let movieCount = fileNameCount(directoryPath: dir, extensionName: "mov")
            var albumDesc: String = ""
            if (imageCount > 0 && movieCount > 0) {
                albumDesc = "\(imageCount) Photo, \(movieCount) Video"
            } else if (imageCount > 0){
                albumDesc = "\(imageCount) Photo"
            } else {
                albumDesc = "\(movieCount) Video"
            }
            
            cell.albumCount.text! = albumDesc
        }
        
        // Adjust cell size
        let photoSize: CGFloat = cellHeight * 0.8
        let photoRect:CGRect = CGRect(x: 0, y: 0, width: photoSize, height: photoSize)
        cell.albumImage.frame = photoRect
        cell.albumImage.center = CGPoint(x: cellHeight * 0.7 , y: cellHeight * 0.5)
        
        cell.albumTitle.frame = CGRect (x: 0, y: 0, width: cellWidth - cellHeight * 1.7, height: cellHeight * 0.3)
        cell.albumTitle.layer.position =  CGPoint(x: cellHeight * 1.5 + (cellWidth - cellHeight * 1.7)/2 , y: cellHeight * 0.3)
        cell.albumCount.frame = CGRect (x: 0, y: 0, width: cellWidth - cellHeight * 1.7, height: cellHeight * 0.15)
        cell.albumCount.layer.position =  CGPoint(x: cellHeight * 1.5 + (cellWidth - cellHeight * 1.7)/2, y: cellHeight * 0.6)
        
        return cell
        
    }
    

     // directoryPath内のextensionName(拡張子)と一致する全てのファイル名
     func fileNameCount(directoryPath: String, extensionName: String) -> Int {
        var allFileName = [String]()
        try?  allFileName  =  FileManager.default.contentsOfDirectory(atPath: directoryPath)
     
     var hitFileNames = [String]()
     for fileName in allFileName {
     if (fileName as NSString).pathExtension == extensionName {
     hitFileNames.append(fileName)
     }
     }
     return hitFileNames.count
     }

    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            // Path to Document/<Albumname>
            let fileManager = FileManager.default
            let pathToCollection = "/collection/" + Albums[indexPath.row]
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: Albums[indexPath.row]) as String
            let dirCollection = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToCollection) as String
            
            do{
                try fileManager.removeItem(atPath: dir)
                try fileManager.removeItem(atPath: dirCollection)
            } catch {
                print("error occured while deleting albums")
            }

            Albums.remove(at: indexPath.row)
            // save album name
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.Albums, forKey: "Albums")
            userDefaults.synchronize()
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        // Add alert dialogue
        let alertController = UIAlertController(title: "New Album", message: "Enter the title of new album", preferredStyle: UIAlertControllerStyle.alert)
        // Add text filed
        alertController.addTextField(configurationHandler: nil)
        
        
        // Add OK button
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(action: UIAlertAction) in
            // When OK button is tapped
            if let textField = alertController.textFields?.first{
                // Check if there already exists the same folder Name
                    for Album in self.Albums {
                        if Album == textField.text! {
                            
                            let alertController1 = UIAlertController(title: "Caution!", message: "You have another album with same name!", preferredStyle: UIAlertControllerStyle.alert)
                            // Add cancel button
                            let alertCancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                            alertController1.addAction(alertCancelAction)
                            // Display alert dialogue
                            self.present(alertController1, animated: true, completion: nil)

                            
                            return
                        }
                    }

                // IF there is no album of the same name
                let fileManager = FileManager.default
                let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: textField.text!) as String
                let pathToCollection = "/collection/" + textField.text!
                let dirCollection = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].stringByAppendingPathComponent1(path: pathToCollection) as String
                
                // Create a new foler path under app Document folder
                if !fileManager.fileExists(atPath: dir) {
                    do {
                        try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
                        try fileManager.createDirectory(atPath: dirCollection, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch {
                        print("Unable to create directory: \(error)")
                    }
                } else {
                    print("There is already the same folder path")
                    return
                }

                // insert new album at the tail of array
                self.Albums += [textField.text!]
                // save album name 
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.Albums, forKey: "Albums")
                userDefaults.synchronize()
                
                // Notify tableview
                self.tableView.insertRows(at: [IndexPath(row: self.Albums.count - 1, section: 0)], with: UITableViewRowAnimation.right)
                
            }

        }
        
        alertController.addAction(okAction)
        // Add cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Display alert dialogue
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "toPhotoViewController"){
            if let cell = sender as? AlbumViewCell {
                if let photoViewController = segue.destination as? PhotoViewController {
                    photoViewController.albumName = cell.albumTitle.text!
                }
            }
        }
    }

}

/*
// サービスの登録フローとかは、いきなりNavigationが出るので
extension UINavigationController {
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations)!
    }
}
*/
// サービスのイントロ画面は、いきなりPageViewControllerなので
/*
extension UINavigationController {
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations)!
    }
}

extension UICollectionViewController {
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
*/
