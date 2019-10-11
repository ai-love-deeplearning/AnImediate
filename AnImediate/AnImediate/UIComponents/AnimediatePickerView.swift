//
//  AnimediatePickerView.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/05.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

public class AnimediatePickerView: UIPickerView {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.showsSelectionIndicator = true
        self.backgroundColor = .white
    }

}
