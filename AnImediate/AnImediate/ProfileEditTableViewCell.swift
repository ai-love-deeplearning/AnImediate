//
//  ProfileEditTableViewCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/07.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class ProfileEditTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
