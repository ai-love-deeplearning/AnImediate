//
//  ProfileEditVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/06.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RSKImageCropper

enum cropType {
    case icon
    case back
}

class ProfileEditVC: UIViewController {
    
    @IBOutlet weak var editTable: UITableView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconBtn: UIButton!
    
    private let editLabels = ["名前", "自己紹介"]
    
    private var cropFlg: cropType = .icon
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTable.delegate = self
        editTable.dataSource = self
        
        icon.layer.cornerRadius = icon.frame.width * 0.5
        iconBtn.layer.cornerRadius = iconBtn.frame.width * 0.5
    }
    
    @IBAction func backgroundBtnTapped(_ sender: Any) {
        cropFlg = .back
        showCameraroll()
    }
    
    @IBAction func iconBtntapped(_ sender: Any) {
        cropFlg = .icon
        showCameraroll()
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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

extension ProfileEditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileEditTableViewCell
        cell.titleLabel.text = editLabels[indexPath.row]
        cell.titleLabel.textColor = .deepMagenta()
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
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
        
        let point1: CGPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let point2: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let point3: CGPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let point4: CGPoint = CGPoint(x: rect.minX, y: rect.minY)
        
        let square: UIBezierPath = UIBezierPath()
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
            background.image = croppedImage
        case .icon:
            icon.image = croppedImage
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
