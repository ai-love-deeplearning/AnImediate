//
//  ProfileEditVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/06.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Photos
import RealmSwift
import ReSwift
import RxSwift
import RxCocoa
import RSKImageCropper

// TODO:- 初回登録と編集画面は分ける。
class ProfileEditVC: UIViewController {
    
    @IBOutlet private weak var editTable: UITableView!
    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var iconBtn: UIButton!
    @IBOutlet private weak var backgroundBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIBarButtonItem!
    @IBOutlet private weak var saveBtn: UIBarButtonItem!
    
    //private var cropFlg: cropType = .icon
    //private var profile: PeerModel = PeerModel()
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    private var viewState: ProfileEditViewState {
        return store.state.profileEditViewState
    }
    
    private var P2PSearchActionCreator: P2PSearchActionCreatable! = nil {
        willSet {
            if P2PSearchActionCreator != nil {
                fatalError()
            }
        }
    }
    
    private var ExchangeAccountActionCreator: ExchangeAccountActionCreatable! = nil {
        willSet {
            if ExchangeAccountActionCreator != nil {
                fatalError()
            }
        }
    }
    
    private var ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable! = nil {
        willSet {
            if ExchangeArchiveActionCreator != nil {
                fatalError()
            }
        }
    }
    
    func inject(P2PSearchActionCreator: P2PSearchActionCreatable, ExchangeAccountActionCreator: ExchangeAccountActionCreatable, ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable) {
        self.P2PSearchActionCreator = P2PSearchActionCreator
        self.ExchangeAccountActionCreator = ExchangeAccountActionCreator
        self.ExchangeArchiveActionCreator = ExchangeArchiveActionCreator
    }
    
    var nameText: String = ""
    var commentText: String = ""
    var iconImage: UIImage = UIImage()
    var backImage: UIImage = UIImage()
    
    var isFirstEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTable.delegate = self
        editTable.dataSource = self
        
        setViews()
        
        bindViews()
        
        if isFirstEdit {
            cancelBtn.isEnabled = false
            cancelBtn.title = ""
        } else {
            cancelBtn.isEnabled = true
            cancelBtn.title = "キャンセル"
        }
    }
    
    private func setViews() {
        icon.image = AccountModel.read().icon
        background.image = AccountModel.read().background
        
        icon.layer.cornerRadius = icon.frame.width * 0.5
        iconBtn.layer.cornerRadius = iconBtn.frame.width * 0.5
    }
    
    private func bindViews() {
        iconBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO:- cropFlg.iconに設定
                //self.store.dispatch()
                self.cropFlg = .icon
                self.showCameraroll()
            })
            .disposed(by: disposeBag)
        
        backgroundBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                self.cropFlg = .back
                self.showCameraroll()
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        saveBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                let model = AccountModel.read()
                // TODO:- Stateからとってくるように変更
                model.name = (self.editTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileEditTableViewCell).contentTF.text!
                model.comment = (self.editTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProfileEditTableViewCell).contentTF.text!
                AccountModel.set(data: model)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func showCameraroll() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    private func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
}

// TODO:- tableviewもRx化する。
extension ProfileEditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileEditTableViewCell
        cell.titleLabel.text = ProfileItem.editLabels[indexPath.row]
        cell.titleLabel.textColor = .deepMagenta()
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        switch indexPath.row {
        case 0:
            cell.contentTF.text = nameText
        case 1:
            cell.contentTF.text = commentText
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        case 1:
            return 100
        default:
            return tableView.rowHeight
        }
    }
    
}

extension ProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: image)
        
        switch cropFlg {
        case .back:
            imageCropVC.cropMode = .custom
        case .icon:
            imageCropVC.cropMode = .circle
        }
        
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(imageCropVC, animated: true)
        }
        //self.dismiss(animated: false)
    }
}

extension ProfileEditVC: RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        var maskSize: CGSize
        var width, height: CGFloat!
        
        width = self.view.frame.width
        height = self.view.frame.width / 2
        
        maskSize = CGSize(width: width, height: height)
        
        let viewWidth: CGFloat = UIScreen.main.bounds.width
        let viewHeight: CGFloat = UIScreen.main.bounds.height
        
        let maskRect: CGRect = CGRect(x: (viewWidth - maskSize.width) * 0.5, y: (viewHeight - maskSize.height) * 0.5, width: maskSize.width, height: maskSize.height)
        return maskRect
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        
        let point1 = CGPoint(x: rect.minX, y: rect.maxY)
        let point2 = CGPoint(x: rect.maxX, y: rect.maxY)
        let point3 = CGPoint(x: rect.maxX, y: rect.minY)
        let point4 = CGPoint(x: rect.minX, y: rect.minY)
        
        let square = UIBezierPath()
        square.move(to: point1)
        square.addLine(to: point2)
        square.addLine(to: point3)
        square.addLine(to: point4)
        square.close()
        
        return square
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    //キャンセルを押した時の処理
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //完了を押した後の処理
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        switch cropFlg {
        case .back:
            background.image = croppedImage.resizeSameAspect()
        case .icon:
            icon.image = croppedImage.resizeSameAspect()
        }
        dismiss(animated: true)
    }
}

extension ProfileEditVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        // キーボードを閉じる処理
        self.view.endEditing(true)
        return true
    }
}
