//
//  AnimeStatusTextFiewld.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/05.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit
import RxSwift

public class AnimeStatusTextField: UITextField {
    private let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
    private let doneBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(done))
    private let blankItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancel))
    
    let disposeBag = DisposeBag()
    
    let statusPickerView = AnimediatePickerView()
    
    @objc func done() {
        self.endEditing(true)
    }
    
    @objc func cancel() {
        self.endEditing(true)
        self.text = ""
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        initToolbar()
        bind()
        
        self.inputAccessoryView = toolbar
        self.inputView = statusPickerView
        
    }
    
    private func initToolbar() {
        doneBtn.tintColor = .MainThema
        cancelBtn.tintColor = .MainThema
        toolbar.backgroundColor = .white
        toolbar.setItems([cancelBtn, blankItem, doneBtn], animated: true)
    }
    
    private func bind() {
        Observable.just(AnimeStatusPickerItems.items)
            .bind(to: statusPickerView.rx.itemTitles) { _, str in
                return str
            }
            .disposed(by: disposeBag)
        
        statusPickerView.rx.modelSelected(String.self)
            .map { strs in
                return strs.first
            }
            .bind(to: self.rx.text)
            .disposed(by: disposeBag)
    }
    
}
