//
//  DataViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/16.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit



class DataViewController: UIViewController {
    
    
    @IBOutlet weak var photoImage: UIImageView!

    var image: UIImage?
    var mediaType: String?
    
    var videoPath: String?
    
    
    // variables for image size
    var scale:CGFloat = 1.0
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    let buttonSize: CGFloat = 100
    
    lazy var button: UIButton = self.createButton()

    // アプリのDocumentディレクトリにある動画ファイルを再生
    func playMovieFromLocalFile() {
        
        let videoPlayer = AVPlayer(url: URL(fileURLWithPath: videoPath!))
        
        // 動画プレイヤーの用意
        let playerController = AVPlayerViewController()
        playerController.player = videoPlayer
        self.present(playerController, animated: true, completion: {
            videoPlayer.play()
        })
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        if mediaType == "video" {
            
            self.view.addSubview(button)
            image = self.setMovieThumbnail(path: videoPath!)
            
        }
        if let photoImage = photoImage  {
            // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
            photoImage.contentMode = UIViewContentMode.scaleAspectFit
            photoImage.image = image
        }
    }
    
    func createButton() -> UIButton {
        // Set Button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.buttonSize, height: self.buttonSize))
        button.addTarget(self, action: #selector(self.playMovieFromLocalFile), for: .touchUpInside)
        
        let buttonImage = UIImage(named: "PlayButton")
        let newImage = self.imageResize(img: buttonImage!)
        button.setImage(newImage, for: UIControlState.normal)
        
        return button
    }
    
    func setMovieThumbnail(path: String) -> UIImage {
        
        // Generate Image for thumbnail
        let avAsset = AVURLAsset(url: URL(fileURLWithPath: path))
        let imgGenerator = AVAssetImageGenerator(asset: avAsset)
        // without following flag, a rotated image will be generated
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage!)
        
        return thumbnail
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (photoImage) != nil {
            self.layoutImage()
        }
        if mediaType == "video"{
            self.layoutButton()
        }
    }
    
    func layoutImage()  {
        // Set display Size
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let displayHeight = myBoundSize.height
        let displayWidth = myBoundSize.width
        
        // Set view frame
        photoImage.frame = CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight)
        
        photoImage.center.x = self.view.center.x
        photoImage.center.y = self.view.center.y
    }
    
    func layoutButton() {
        button.center.x = self.view.center.x
        button.center.y = self.view.center.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // change button image size depending on the view frame
    func imageResize(img:UIImage) -> UIImage{
        
        let rect = CGRect(x:0, y:0, width:self.buttonSize, height:self.buttonSize)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:self.buttonSize, height:self.buttonSize), false, 1.0)
        img.draw(in: rect)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
