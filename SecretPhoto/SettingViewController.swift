//
//  AlbumViewController.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/11.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = "パスワードの変更"
        
        self.tableView.separatorStyle = .none
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

