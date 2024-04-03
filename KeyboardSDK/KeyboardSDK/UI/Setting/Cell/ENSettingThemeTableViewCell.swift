//
//  ENSettingThemeTableViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/20.
//

import UIKit

import KeyboardSDKCore


protocol ENSettingThemeTableViewCellDelegate: AnyObject {
    func showThemeListWith(theme:ENKeyboardThemeModel?)
}


class ENSettingThemeTableViewCell: UITableViewCell {
    
    static let ID:String = "ENSettingThemeTableViewCell"
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescript: UILabel!
    
    @IBOutlet weak var imageViewPopular1: UIImageView!
    @IBOutlet weak var imageViewPopular2: UIImageView!

    
    
    
    weak var delegate:ENSettingThemeTableViewCellDelegate?
    
    private var popularTheme:ENKeyboardThemeListModel? = nil
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        
        imageViewPopular1.isUserInteractionEnabled = true
        imageViewPopular2.isUserInteractionEnabled = true
        
        imageViewPopular1.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestureExcute(gesture:))))
        imageViewPopular2.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestureExcute(gesture:))))
    }
    
    func updatePopularTheme() {
        
        let request:DHNetwork = DHApi.themePopularList(userId: "")
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<ENKeyboardThemeListModel, DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                self.popularTheme = retValue
                DispatchQueue.main.async {
                    
                    guard let themes = self.popularTheme, let data = themes.data, data.count > 0 else {
                        self.imageViewPopular1.isHidden = true
                        self.imageViewPopular2.isHidden = true
                        return
                    }
                    
                    self.imageViewPopular1.isHidden = false
                    self.imageViewPopular1.loadImageAsync(with: data[0].image)
                    
                    if data.count > 1 {
                        self.imageViewPopular2.isHidden = false
                        self.imageViewPopular2.loadImageAsync(with: data[1].image)
                    }
                }
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
            @unknown default:
                break
            }
        }
    }
    
    
    @objc private func tapGestureExcute(gesture:UITapGestureRecognizer) {
        guard let themes = self.popularTheme, let data = themes.data, data.count > 0 else {
            return
        }
        
        
        switch gesture.view {
        case imageViewPopular1:
            delegate?.showThemeListWith(theme: data[0])
            return
            
        case imageViewPopular2:
            if data.count > 1 {
                delegate?.showThemeListWith(theme: data[1])
            }
            return
            
        default:
            return
        }
        
    }
}

