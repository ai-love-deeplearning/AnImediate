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
import RxDataSources
import RSKImageCropper

// TODO:- 初回登録と編集画面は分ける。
class ProfileEditVC: UIViewController {
    
    @IBOutlet private weak var editTable: UITableView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var iconBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIBarButtonItem!
    @IBOutlet private weak var saveBtn: UIBarButtonItem!
    
    //private var cropFlg: cropType = .icon
    //private var profile: PeerModel = PeerModel()
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    private var viewState: ProfileEditViewState {
        return store.state.profileEditViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ProfileSectionModel>!
    private var sectionModels: [ProfileSectionModel]!
    private var dataRelay = BehaviorRelay<[ProfileSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSectionModels()
        initTable()
        bindViews()
        fetch()
        
        if CommonStateModel.read().isRegistered {
            setViews()
            cancelBtn.isEnabled = true
            cancelBtn.title = "キャンセル"
        } else {
            cancelBtn.isEnabled = false
            cancelBtn.title = ""
        }
    }
    
    private func setViews() {
        icon.image = AccountModel.read().icon
        icon.layer.cornerRadius = icon.frame.width * 0.5
        iconBtn.layer.cornerRadius = iconBtn.frame.width * 0.5
    }
    
    private func bindViews() {
        // dataRelayの変更をキャッチしてdataSourceにデータを流す
        dataRelay.asObservable()
            .bind(to: editTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // アイテム削除時
        editTable.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
                var items = sectionModel.items
                items.remove(at: indexPath.row)
                
                strongSelf.sectionModels = [ProfileSectionModel(items: items)]
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
        
        editTable.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        iconBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO:- cropFlg.iconに設定
                self.store.dispatch(ProfileEditViewAction.CangeCropType(cropType: .icon))
                self.showCameraroll()
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO:- 各項目にデフォルト値を設定するか、初回登録時必須にしてキャンセルできないようにするか
                CommonStateModel.set(isRegistered: true)
//                self.store.dispatch(ProfileEditViewAction.Registered())
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        saveBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO:- Rx化してStateからとってくるように変更
                let idCell = self.editTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileEditTableViewCell
                let nameCell = self.editTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProfileEditTableViewCell
                let commentCell = self.editTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! ProfileEditCommentTableViewCell
                
                let idSuccess = idCell.saveData()
                let nameSuccess = nameCell.saveData()
                let commentSuccess = commentCell.saveData()
                AccountModel.set(icon: self.icon.image!.resizeSameAspect()!)
                
                // 初回登録時
                
                if !idSuccess || !nameSuccess || !commentSuccess {
                    let msg = "空白の項目があります"
                    self.showAlert(title: "", message: msg)
                    return
                }
                
                CommonStateModel.set(isRegistered: true)
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    private func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
}

extension ProfileEditVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1:
            return 64
        case 2:
            return 152
        default:
            return tableView.rowHeight
        }
    }
    
}

extension ProfileEditVC {
    private func initSectionModels() {
        
        // TODO:- UserIDは初回必須登録項目で、全ユーザを通してユニークである必要がある。
        // TODO:- firebaseでユーザ情報を管理？
        
        let items = [
            ProfileModel(label: ProfileItem.editLabels[0], content: AccountModel.read().userID),
            ProfileModel(label: ProfileItem.editLabels[1], content: AccountModel.read().name),
            ProfileModel(label: ProfileItem.editLabels[2], content: AccountModel.read().comment)]
        sectionModels = [ProfileSectionModel(items: items)]
    }
    
    private func initTable() {
        
        editTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                
                switch indexPath.row {
                case 0, 1:
                    // 引数名通り、与えられたデータを利用してcellを生成する
                    let cell = self.editTable.dequeueReusableCell(withIdentifier: "ProfileEditCell", for: IndexPath(row: indexPath.row, section: 0)) as! ProfileEditTableViewCell
                    
                    cell.setData(item.label, item.content)
                    
                    return cell
                case 2:
                    // 引数名通り、与えられたデータを利用してcellを生成する
                    let cell = self.editTable.dequeueReusableCell(withIdentifier: "ProfileEditCommentCell", for: IndexPath(row: indexPath.row, section: 0)) as! ProfileEditCommentTableViewCell
                    
                    cell.setData(item.label, item.content)
                    
                    return cell
                default:
                    return UITableViewCell()
                }
        }, canEditRowAtIndexPath: { _, _ in
            // この引数を設定しないと、Cellの削除アクションができない
            return false
        })
    }
    
    // 初期表示用のデータフェッチする処理
    private func fetch() {
        
        Observable.just(sectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: image)
        
        switch viewState.cropType {
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
        
        switch viewState.cropType {
        case .back:
            break
//            background.image = croppedImage.resizeSameAspect()
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
