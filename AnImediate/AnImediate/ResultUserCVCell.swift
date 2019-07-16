//
//  ResultUserCVCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class ResultUserCVCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func bindData(userInfo: UserInfo) {
        self.userId = userInfo.id
        
        self.iconImageView.image = UIImage(data: userInfo.iconData! as Data)!
        self.nameLabel.text = userInfo.name
    }
}
