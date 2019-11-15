//
//  AnimeCardTableViewCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/04.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import FirebaseUI

class AnimeCardTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    
    var anime: AnimeModel? {
        didSet {
            setImage("iconImages/\(anime!.annictID).jpg")
            seasonLabel.text = anime?.seasonNameText
            titleLabel.text = anime?.title
            synopsisLabel.text = anime?.synopsis
            // TODO:- 見た人なのか登録した人なのか
            registerLabel.text = String(anime?.watchersCount ?? 0)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let background = UIView()
        background.backgroundColor = .LightThema
        selectedBackgroundView = background
    }

}
