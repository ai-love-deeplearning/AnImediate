//
//  RecomCollectionViewCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class RecomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recomImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageURL = ""
    var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func bindData(work: Work) {
        imageURL = work.imageUrl
        titleLabel.text = work.title
        seasonText = work.seasonNameText
        
        setIconImageView(imageUrlString: work.imageUrl)
        recomImageView.contentMode = .scaleAspectFill
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            DispatchQueue.main.async(execute: {
                self.recomImageView.image = image
            })
        }
        downloadImageTask.resume()
    }
}
