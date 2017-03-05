//
//  AlbumViewCell.swift
//  SecretPhoto
//
//  Created by kawahara keisuke on 2017/02/11.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import UIKit

class AlbumViewCell: UITableViewCell{
    
    
    @IBOutlet weak var albumImage: UIImageView!
    
    @IBOutlet weak var albumTitle: UILabel!
    
    @IBOutlet weak var albumCount: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 */
}
