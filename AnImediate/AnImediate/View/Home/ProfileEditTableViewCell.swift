//
//  ProfileEditTableViewCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/07.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit

class ProfileEditTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setData(_ title: String, _ content: String) {
        titleLabel.text = title
        contentTF.text = content
        contentTF.attributedPlaceholder = NSAttributedString(string: "\(title)を入力", attributes: [NSAttributedString.Key.foregroundColor : UIColor.TextLightGray])
    }
    
    public func saveData() -> Bool {
        guard let text = contentTF.text else { return false }
        if text.isEmpty {
            return false
        }
        switch titleLabel.text {
        case ProfileItem.editLabels[0]:
            AccountModel.set(uid: text)
            return true
        case ProfileItem.editLabels[1]:
            AccountModel.set(name: text)
            return true
        default:
            break
        }
        return false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
