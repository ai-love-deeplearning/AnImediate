//
//  ThisTermCollectionViewCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/02.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class ThisTermCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var animeID = ""
    var imageURL = ""
    var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func bindData(work: Work) {
        animeID = work.id
        imageURL = work.imageUrl
        titleLabel.text = work.title
        titleLabel.textColor = .deepMagenta()
        seasonText = work.seasonNameText
        
        setIconImageView(imageUrlString: work.imageUrl)
        iconImageView.contentMode = .scaleAspectFill
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
