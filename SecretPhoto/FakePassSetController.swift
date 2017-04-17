//
//  FakePassSetController.swift
//  SecretPhoto
//
//  Created by 河原圭佑 on 2017/03/07.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//
// This class sets a fake password for calculator


import UIKit
import AVKit
import AVFoundation
import Photos

class FakePassSetController: InitialSetController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction override func tapRegisterButton(_ sender: Any) {
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
                //userDefaults.set(true, forKey: "initFlag")
                userDefaults.set(passNumber, forKey: "fakePassword")
                userDefaults.synchronize()
                
                
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
}
