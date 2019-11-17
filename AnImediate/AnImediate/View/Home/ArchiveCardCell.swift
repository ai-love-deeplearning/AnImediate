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
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setArchive(_ archive: ArchiveModel) {
        let anime = AnimeModel.read(annictID: archive.annictID)
        titleLabel.text = anime.title
        seasonLabel.text = anime.seasonNameText
        
        setImage("iconImages/\(anime.annictID).jpg")
        iconImageView.contentMode = .scaleAspectFill
    }
    
    private func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}

