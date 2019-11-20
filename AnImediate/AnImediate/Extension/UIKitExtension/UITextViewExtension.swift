//
//  UITextViewExtension.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/11/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class InspectableTextView: UITextView {
    // MARK: - プロパティ
    /// プレースホルダーに表示する文字列（ローカライズ付き）
    @IBInspectable var localizedString: String = "" {
        didSet {
            guard !localizedString.isEmpty else { return }
            // Localizable.stringsを参照する
            placeholderLabel.text = NSLocalizedString(localizedString, comment: "")
            placeholderLabel.sizeToFit()  // 省略不可
        }
    }

    /// プレースホルダー用ラベルを作成
    private lazy var placeholderLabel = UILabel(frame: CGRect(x: 3, y: 6, width: 0, height: 0))
    private let disposeBag = DisposeBag()

    // MARK: - Viewライフサイクルメソッド
    /// ロード後に呼ばれる
    override public func awakeFromNib() {
        super.awakeFromNib()
        configurePlaceholder()
        bindView()
    }

    /// プレースホルダーを設定する
    private func configurePlaceholder() {
        placeholderLabel.textColor = .TextLightGray
        addSubview(placeholderLabel)
    }
    
    private func bindView() {
        self.rx.text.asDriver()
            .drive(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                guard let text = text else { return }
                strongSelf.placeholderLabel.isHidden = text.isEmpty ? false : true
        })
        .disposed(by: disposeBag)
        
    }

    /// プレースホルダーの表示・非表示切り替え
    private func togglePlaceholder() {
        // テキスト未入力の場合のみプレースホルダーを表示する
        placeholderLabel.isHidden = text.isEmpty ? false : true
    }
    
}
