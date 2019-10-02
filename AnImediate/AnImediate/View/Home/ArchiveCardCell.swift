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
            setIconImageView(imageUrlString: anime!.imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            DispatchQueue.main.async(execute: {
                self.iconImageView.image = image
            })
        }
        downloadImageTask.resume()
    }
    
}

