//
//  ProfileEditCommentTableViewCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/11/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit

class ProfileEditCommentTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTextView: InspectableTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func reloadTintColor() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0)
        UIView.setAnimationDelay(0)
        UIView.setAnimationCurve(.linear)

        contentTextView.becomeFirstResponder()
        contentTextView.resignFirstResponder()

        UIView.commitAnimations()
    }
    
    public func setData(_ title: String, _ content: String) {
        titleLabel.text = title
        contentTextView.text = content
        reloadTintColor()
    }
    
    public func saveData() -> Bool {
        if contentTextView.text.isEmpty {
            return false
        }
        AccountModel.set(comment: contentTextView.text)
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
