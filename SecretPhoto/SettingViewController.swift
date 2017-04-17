//
//  AlbumViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/11.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    
    @IBOutlet weak var passInitializationLabel: UILabel!
    @IBOutlet weak var fakePassSetLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        passInitializationLabel.text = "パスワードの変更"
        fakePassSetLabel.text = "フェイクパスワードの設定"
        self.tableView.separatorStyle = .none
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Your action here
        if indexPath.row == 0 {
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "InitialSetController") as! InitialSetController
            self.present(nextView, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "FakePassSetController") as! FakePassSetController
            self.present(nextView, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

