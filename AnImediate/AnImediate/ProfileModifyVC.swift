//
//  ProfileModifyVC.swift
//  AnImediate
//
//  Created by 崎野也真人 on 2019/06/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RSKImageCropper

class ProfileModifyVC: UIViewController {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let image = UIImage(named: "img")!
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self
        
        present(imageCropVC, animated: true)
    }
    

}
    extension ProfileModifyVC: RSKImageCropViewControllerDelegate {
    //キャンセルを押した時の処理
        func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
            dismiss(animated: true, completion: nil)
        }
    //完了を押した後の処理
        func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
            dismiss(animated: true)
            thumbnail.image = croppedImage
        }
    }
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


