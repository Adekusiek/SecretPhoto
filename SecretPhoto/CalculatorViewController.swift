//
//  numberViewController.swift
//  MySecondApp
//
//  Created by kawahara keisuke on 2017/01/18.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit
import AudioToolbox

class CalculatorViewController: UIViewController {
    
    
    var holdValue: Double = 0.0
    var currentValue: Double = 0.0
    
    enum operant: String {
        case plus
        case minus
        case multiply
        case divide
        case none
    }
    
    var holdOperant: operant = .none

    var waitFlag: Bool = false
    
    @IBOutlet weak var numberField: MyTextField!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var commaButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var plusMinusButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    
    var passwordHolder: String = ""
    
    let systemSoundID:SystemSoundID = 1306
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load current display frame size
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let displayHeight = myBoundSize.height
        let displayWidth = myBoundSize.width
        
        // Calculate  size
        //let edgeSize: CGFloat = self.view.frame.size.width/4
        let edgeSize: CGFloat = displayWidth/4 - 0.05
        zeroButton.frame = CGRect(x:0, y:displayHeight - edgeSize, width: edgeSize * 2, height: edgeSize)
        commaButton.frame = CGRect(x:edgeSize * 2, y:displayHeight - edgeSize, width: edgeSize, height: edgeSize)
        equalButton.frame = CGRect(x:edgeSize * 3, y:displayHeight - edgeSize, width: edgeSize, height: edgeSize)
        oneButton.frame = CGRect(x:0, y:displayHeight - edgeSize * 2, width: edgeSize, height: edgeSize)
        twoButton.frame = CGRect(x:edgeSize, y:displayHeight - edgeSize * 2, width: edgeSize, height: edgeSize)
        threeButton.frame = CGRect(x:edgeSize * 2, y:displayHeight - edgeSize * 2, width: edgeSize, height: edgeSize)
        plusButton.frame = CGRect(x:edgeSize * 3, y:displayHeight - edgeSize * 2, width: edgeSize, height: edgeSize)
        fourButton.frame = CGRect(x:0, y:displayHeight - edgeSize * 3, width: edgeSize, height: edgeSize)
        fiveButton.frame = CGRect(x:edgeSize, y:displayHeight - edgeSize * 3, width: edgeSize, height: edgeSize)
        sixButton.frame = CGRect(x:edgeSize * 2, y:displayHeight - edgeSize * 3, width: edgeSize, height: edgeSize)
        minusButton.frame = CGRect(x:edgeSize * 3, y:displayHeight - edgeSize * 3, width: edgeSize, height: edgeSize)
        sevenButton.frame = CGRect(x:0, y:displayHeight - edgeSize * 4, width: edgeSize, height: edgeSize)
        eightButton.frame = CGRect(x:edgeSize, y:displayHeight - edgeSize * 4, width: edgeSize, height: edgeSize)
        nineButton.frame = CGRect(x:edgeSize * 2, y:displayHeight - edgeSize * 4, width: edgeSize, height: edgeSize)
        multiplyButton.frame = CGRect(x:edgeSize * 3, y:displayHeight - edgeSize * 4, width: edgeSize, height: edgeSize)
        clearButton.frame = CGRect(x:0, y:displayHeight - edgeSize * 5, width: edgeSize, height: edgeSize)
        plusMinusButton.frame = CGRect(x:edgeSize, y:displayHeight - edgeSize * 5, width: edgeSize, height: edgeSize)
        percentButton.frame = CGRect(x:edgeSize * 2, y:displayHeight - edgeSize * 5, width: edgeSize, height: edgeSize)
        divideButton.frame = CGRect(x:edgeSize * 3, y:displayHeight - edgeSize * 5, width: edgeSize, height: edgeSize)
        numberField.frame = CGRect(x:0, y:0, width: displayWidth, height: displayHeight - edgeSize * 5)
        
        let userDefaults = UserDefaults.standard
        passwordHolder = userDefaults.string(forKey: "password")!
        
        
        // Adjust Fonto position
        // Take a margine on right side
        zeroButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, edgeSize)
        
        numberField.padding = UIEdgeInsetsMake(edgeSize * 0.8, edgeSize/5, 0, edgeSize/5)
        
        // Add effects on heighlited button
        zeroButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        oneButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        twoButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        threeButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        fourButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        fiveButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        sixButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        sevenButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        eightButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        nineButton.setBackgroundImage(Color.imageWithColor(color: UIColor.brown), for: .highlighted)
        clearButton.setBackgroundImage(Color.imageWithColor(color: UIColor.gray), for: .highlighted)
        plusMinusButton.setBackgroundImage(Color.imageWithColor(color: UIColor.gray), for: .highlighted)
        percentButton.setBackgroundImage(Color.imageWithColor(color: UIColor.gray), for: .highlighted)
        equalButton.setBackgroundImage(Color.imageWithColor(color: UIColor.orange), for: .highlighted)
        plusButton.setBackgroundImage(Color.imageWithColor(color: UIColor.orange), for: .highlighted)
        minusButton.setBackgroundImage(Color.imageWithColor(color: UIColor.orange), for: .highlighted)
        multiplyButton.setBackgroundImage(Color.imageWithColor(color: UIColor.orange), for: .highlighted)
        divideButton.setBackgroundImage(Color.imageWithColor(color: UIColor.orange), for: .highlighted)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tap0Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)
        
        if waitFlag == true {
            numberField.text!  = "0"
            waitFlag = false
            return
        }
        
        setValue(value: "0")
        self.checkPassword()

    }
    
    @IBAction func tap1Button(_ sender: Any) {

        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "1"
            waitFlag = false
            return
        }

        setValue(value: "1")
        self.checkPassword()

    }
    
    @IBAction func tap2Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "2"
            waitFlag = false
            return
        }

        setValue(value: "2")
        self.checkPassword()
        
    }
    
    
    @IBAction func tap3Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "3"
            waitFlag = false
            return
        }

        setValue(value: "3")
        self.checkPassword()
        
    }
    
    
    @IBAction func tap4Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "4"
            waitFlag = false
            return
        }

        setValue(value: "4")
        self.checkPassword()

    }
    
    
    @IBAction func tap5Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "5"
            waitFlag = false
            return
        }

        setValue(value: "5")
        self.checkPassword()

    }
    
    
    @IBAction func tap6Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)


        if waitFlag == true {
            numberField.text!  = "6"
            waitFlag = false
            return
        }
        
        setValue(value: "6")
        self.checkPassword()
        
    }
    
    @IBAction func tap7Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)
        
        if waitFlag == true {
            numberField.text!  = "7"
            waitFlag = false
            return
        }
        
        setValue(value: "7")
        self.checkPassword()

    }
    
    
    @IBAction func tap8Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "8"
            waitFlag = false
            return
        }

        setValue(value: "8")
        self.checkPassword()

    }
    
    @IBAction func tap9Button(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "9"
            waitFlag = false
            return
        }

        setValue(value: "9")
        self.checkPassword()
        
    }
    
    @IBAction func tapCButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        numberField.text! = "0"
        self.clearBorderWidth()
        
    }

    @IBAction func tapDivideButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        holdValue = NSString(string: numberField.text!).doubleValue
        holdOperant = .divide
        waitFlag = true
        self.clearBorderWidth()
        divideButton.layer.borderWidth = 2

    }

    @IBAction func tapMultiplyButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        holdValue = NSString(string: numberField.text!).doubleValue
        holdOperant = .multiply
        waitFlag = true
        self.clearBorderWidth()
        multiplyButton.layer.borderWidth = 2

    }
    
    @IBAction func tapMinusButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        holdValue = NSString(string: numberField.text!).doubleValue
        holdOperant = .minus
        waitFlag = true
        self.clearBorderWidth()
        minusButton.layer.borderWidth = 2

    }
    
    @IBAction func tapPlusButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        holdValue = NSString(string: numberField.text!).doubleValue
        holdOperant = .plus
        waitFlag = true
        self.clearBorderWidth()
        plusButton.layer.borderWidth = 2

    }
    
    @IBAction func tapEqualButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        currentValue = NSString(string: numberField.text!).doubleValue
        
        switch holdOperant {
        case .plus:
            let calculatedValue = holdValue + currentValue
            holdValue = calculatedValue
            waitFlag = true
            numberField.text = self.integerCheck(value: calculatedValue)

        
        case .minus:
            let calculatedValue = holdValue - currentValue
            holdValue = calculatedValue
            waitFlag = true
            numberField.text = self.integerCheck(value: calculatedValue)

        
        case .multiply:
            let calculatedValue = holdValue * currentValue
            holdValue = calculatedValue
            waitFlag = true
            numberField.text = self.integerCheck(value: calculatedValue)

        
        case .divide:
            if currentValue != 0 {
                let calculatedValue = holdValue / currentValue
                holdValue = calculatedValue
                waitFlag = true
                numberField.text = self.integerCheck(value: calculatedValue)

            
            } else {
                numberField.text! = "Error"
                waitFlag = true
            }
            
        default:
            break
        }
        self.clearBorderWidth()
        equalButton.layer.borderWidth = 2


    }

    
    @IBAction func tapPercentButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)
        
        let value = NSString(string: numberField.text!).doubleValue
        let calculatedValue = 0.01 * value
        numberField.text = self.integerCheck(value: calculatedValue)
    }

    @IBAction func tapPlusMinusButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        let value = NSString(string: numberField.text!).doubleValue
        let calculatedValue = Double(-1) * value
        numberField.text = self.integerCheck(value: calculatedValue)

    }
    
    @IBAction func tapCommaButton(_ sender: Any) {
        
        AudioServicesPlaySystemSound(systemSoundID)

        if waitFlag == true {
            numberField.text!  = "0."
            waitFlag = false
            return
        }
        
        let value = numberField.text!
        let number = NSString(string: value).doubleValue
        if  value == self.integerCheck(value: number) {
            numberField.text = value + "."
        }
    }
    
    func setValue(value: String) {
        if numberField.text!.characters.count < 10 {
            let nextValue = numberField.text! + value
            let number = NSString(string: nextValue).doubleValue
            numberField.text = self.integerCheck(value: number)
        }
    }
    
    
    /* This function checks current value is interger or not */
    
    func integerCheck(value: Double) -> String {
        let intValue = Int(value)
        let reversedValue = Double(intValue)
        if reversedValue == value {
            return String(intValue)
        } else {
            return String(value)
        }
    }
    
    
    
    func checkPassword() {
        let input = numberField.text!
        if passwordHolder == input {
            performSegue(withIdentifier: "toAlbumViewController", sender: nil)
        }
        print(input)
    }
    
    
    func clearBorderWidth(){
        let originalWidth: CGFloat = 0.5
        plusButton.layer.borderWidth = originalWidth
        minusButton.layer.borderWidth = originalWidth
        multiplyButton.layer.borderWidth = originalWidth
        divideButton.layer.borderWidth = originalWidth
        equalButton.layer.borderWidth = originalWidth
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    // 指定方向に自動的に回転
    override open var shouldAutorotate: Bool {
        return true
    }

}
