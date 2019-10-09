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

class AnimeCardTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    
    var anime: AnimeModel? {
        didSet {
            setIconImageView(imageUrlString: anime!.imageUrl)
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
    
    func saveModel() {
        
    }
    
    func border() {
        self.layer.borderColor = UIColor.deepMagenta().cgColor
        self.layer.borderWidth = 2
    }
    
    func unborder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
