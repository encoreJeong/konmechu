//
//  TapBarController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMiddleButton()
    }
    
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.6549019608, blue: 1, alpha: 1)
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.layer.borderWidth = 2
        menuButton.layer.borderColor = UIColor.white.cgColor
        
//            menuButton.layer.shadowOpacity = 1
//            menuButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//            menuButton.layer.shadowRadius = 0.5
        
        view.addSubview(menuButton)
        view.bringSubviewToFront(menuButton)
        
        
        if let image = UIImage(systemName: "plus.viewfinder") { // "heart.fill"은 예시입니다. 원하는 system 이미지 이름으로 변경하세요.

            // 색상 변경
            let tintedImage = image.withTintColor(.black, renderingMode: .alwaysOriginal)
            // 이미지 크기 조절
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .default) // 여기에서 원하는 크기와 무게, 스케일을 설정하세요.
            let largeImage = tintedImage.applyingSymbolConfiguration(largeConfig)

            // UIButton에 이미지 설정
            menuButton.setImage(largeImage, for: .normal)
        }

            menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

            view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
       performSegue(withIdentifier: "SmartlensSG", sender: nil)
    }

}
