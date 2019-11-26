//
//  ExchangeTopTableViewCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/11/18.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit

class ExchangeTopTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var registerCountLabel: UILabel!
    @IBOutlet weak var commonCountLabel: UILabel!
    @IBOutlet weak var exchangeDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.cornerRadius = iconImageView.frame.width * 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(peer: PeerModel) {
        let peerArchives = Array(ArchiveModel.read(uid: peer.userID))
        let myArchives = Array(ArchiveModel.read(uid: AccountModel.read().userID))
        
        let common = peerArchives.map{ $0.annictID }.intersect(myArchives.map{ $0.annictID })
//        let onlyMe = peerArchives.except(myArchives)
//        let onlyPeer = myArchives.except(peerArchives)
        
        userNameLabel.text = peer.name
        registerCountLabel.text = String(peerArchives.count)
        commonCountLabel.text = String(common.count)
        exchangeDateLabel.text = peer.excangedAt
        iconImageView.image = peer.icon
    }

}
