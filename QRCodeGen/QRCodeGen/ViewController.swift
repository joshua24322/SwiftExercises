//
//  ViewController.swift
//  QRCodeGen
//
//  Created by Joshua Chang on 2018/10/23.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//
// reference from 「https://www.appcoda.com.tw/qr-code-generator-tutorial/」

import UIKit

class ViewController: UIViewController {
    
    var qrcodeImage:CIImage! // QRCode 圖片
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imgQRCode: UIImageView! // 圖片像框物件
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBAction func performButtonAction(_ sender: Any) {
        if qrcodeImage == nil {
            if textField.text == "" { return }
            
            let data = textField.text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) // isoLatin1 = iso-8859-1， corresponds the first 256 code bits of Unicode, apple recommend use isoLatin1 rather utf8.
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            // inputMessage: 轉換QRCode圖片的初始資料。 參數必須是NSData物件， Data型別橋接到NSData class 以及其可變子類 NSMutableData
            
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            // inputCorrectionLevel: 表示有多少額外的錯誤更正資料要被附加到輸出的QRCode圖片中， 參數有4種，「L, M, Q, M」分別對應不同的錯誤修復能力，依序為「7%, 15%, 25%, 30%」，數值愈大，輸出的QRCode圖片也就愈大。
            
            qrcodeImage = filter?.outputImage
            
//            imgQRCode.image = UIImage(ciImage: qrcodeImage)
            displayQRCodeImage()
            textField.resignFirstResponder()
            
            btnAction.setTitle("Clear", for: UIControl.State.normal)
//            slider.isHidden = false
        } else {
            imgQRCode.image = nil
            qrcodeImage = nil
            btnAction.setTitle("Generate", for: UIControl.State.normal)
        }
        
        textField.isEnabled = !textField.isEnabled // 文字欄位切換成可編輯或不可編輯
        slider.isHidden = !slider.isHidden // 滑桿切換成隱藏或看得見
    }
    
    @IBAction func changeImageViewScale(_ sender: Any) {
        imgQRCode.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value))
    }
    
    func displayQRCodeImage() {
        // 指定X軸與Y軸縮放係數 (圖片視圖的長寬 / QRCode圖片的長寬， extent屬性會回傳圖片的外框)
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        // transformed(by:) Returns a new image that represents the original image after applying an affine transform
        // 將縮放轉換好的QRCode圖片，回傳給新建立的圖片物件
        
        imgQRCode.image = UIImage(ciImage: transformedImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

