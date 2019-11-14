//
//  ArchiveCardCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/02.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import FirebaseUI

final class ArchiveCardCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var resisterCountLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    var anime: AnimeModel? {
        didSet {
            titleLabel.text = anime?.title
            synopsisLabel.text = anime?.synopsis
            seasonLabel.text = anime?.seasonNameText
            // TODO:- 見た人なのか登録した人なのか
            resisterCountLabel.text = String(anime?.watchersCount ?? 0)
            setImage(anime!.annictID)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}

