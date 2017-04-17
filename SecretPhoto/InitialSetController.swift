//
//  InitialSetController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/22.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

//
//  DataViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/16.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos

class InitialSetController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passView: UITextField!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var passLabel: UILabel!
    
    var numberOfPassInput: Int = 0
    var previousPassInput: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passView.keyboardType =  UIKeyboardType.numberPad
        
        passView.delegate = self
        
        passView.addTarget(self, action: #selector(passFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        passButtonLayout()
        passViewLayout()
        passLabelLayout()
        
        // シングルタップ
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(InitialSetController.tapSingle(sender:)))  //Swift3
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        
    }
    
    func passViewLayout() {
        passView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: 50)
        passView.center.x = view.center.x
        passView.center.y = view.center.y * 0.6
        passView.placeholder = "9桁以下の数字"
    }
    
    func passButtonLayout()  {
        passButton.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.3, height: 50)
        passButton.center.x = view.center.x
        passButton.center.y = view.center.y * 0.9
        passButton.setTitle("登録", for: .normal)
    }
    
    func passLabelLayout()  {
        passLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: 80)
        passLabel.center.x = view.center.x
        passLabel.center.y = view.center.y * 0.3
        passLabel.text = "パスワードを設定してください"
    }
    
    @IBAction func tapScreen(_ sender: Any) {
        
        self.view.endEditing(true)
        passView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func passFieldDidChange(textField: UITextField) {
        let input = passView.text!
        if let value = Int64(input) {
            passView.text! = "\(value)"
            if value > 1000000000000 {
                 passView.text! = "999999999"
            }
        }
        
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        if numberOfPassInput == 0 {
            previousPassInput = passView.text!
            numberOfPassInput = 1
            passView.text! = ""
            passView.placeholder = "9桁以下の数字"
            passLabel.text = "パスワードもう一度入力してください"

        } else {
            if previousPassInput == passView.text! {
                let passNumber = Int(previousPassInput)
                let userDefaults = UserDefaults.standard

                userDefaults.set(true, forKey: "initFlag")
                userDefaults.set(passNumber, forKey: "truePassword")
                userDefaults.synchronize()
                                
                libraryRequestAuthorization()
                cameraSelected()
                microSelected()
                
                let nextView = self.storyboard!.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
                self.present(nextView, animated: true, completion: nil)
                
            } else {
                passView.text! = ""
                passView.placeholder = "パスワードが一致しませんでした"
                passLabel.text = "パスワードを入力してください"
                previousPassInput = ""
                numberOfPassInput = 0
            }
        }
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
            case .denied: break;
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
    
    
    func permissionPrimeCameraAccess() {
        let alert = UIAlertController( title: "\"<Your App>\" Would Like To Access the Camera", message: "user can use camera", preferredStyle: .alert )
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
            case .denied: break;
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
    
    /// シングルタップ時に実行される
    func tapSingle(sender: UITapGestureRecognizer) {
        // キーボードを閉じる
        passView.resignFirstResponder()
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
    }

}
