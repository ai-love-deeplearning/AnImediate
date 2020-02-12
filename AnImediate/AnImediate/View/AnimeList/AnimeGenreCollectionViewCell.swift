//
//  AnimeGenreCollectionViewCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/11/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import AppConfig
import AppModel
import Firebase
import FirebaseUI

class AnimeGenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    
    private var imageURL = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.contentMode = .scaleAspectFill
    }
    
    public func setData(anime: AnimeModel) {
        imageURL = anime.imageUrl
        titleLabel.text = anime.title
        companyLabel.text = anime.company
    }
    
    public func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
    public func setRank(index: Int) {
        rankLabel.text = "\(index+1)位"
    }
    
    public func displayLine(index: Int) {
        if (index % 3) == 0 {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
    }
}
