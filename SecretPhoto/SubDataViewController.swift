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

class SubDataViewController: DataViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subPhotoImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        subPhotoImage.contentMode = UIViewContentMode.scaleAspectFit
        subPhotoImage.image = image
        
        self.scrollView.delegate = self

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(SubDataViewController.tapDouble(gesture:)))  //Swift3
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        

        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 4
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (subPhotoImage) != nil {
            self.layoutimage()
        }
    }
    
    func layoutimage()  {
        // Set display Size
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let displayHeight = myBoundSize.height
        let displayWidth = myBoundSize.width
        
        // Set view frame
        subPhotoImage.frame = CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight)
        scrollView.frame = CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight)

        subPhotoImage.center.x = self.view.center.x
        subPhotoImage.center.y = self.view.center.y
    }
    

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print("pinch")
        return self.subPhotoImage
    }

    func tapDouble(gesture: UITapGestureRecognizer) -> Void {

        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
            let newScale = self.scrollView.zoomScale * 2
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.scrollView.setZoomScale(1.0, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        let size = CGSize(
            width: self.scrollView.frame.size.width / scale,
            height: self.scrollView.frame.size.height / scale
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }
    
    
    
}
