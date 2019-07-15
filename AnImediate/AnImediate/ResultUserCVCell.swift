//
//  ResultUserCVCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class ResultUserCVCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func bindData(userInfo: UserInfo) {
        
        self.iconImageView.image = userInfo._icon
        self.nameLabel.text = userInfo.name
    }
}
