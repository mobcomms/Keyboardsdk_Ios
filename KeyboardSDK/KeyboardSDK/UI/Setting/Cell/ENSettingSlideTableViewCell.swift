//
//  ENSettingSlideTableViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/31.
//

import UIKit

protocol ENSettingSlideTableViewCellDelegate: AnyObject {
    func slideValueChanged(cell: ENSettingSlideTableViewCell, newValue:Float)
}


class ENSettingSlideTableViewCell: UITableViewCell {

    static let ID:String = "ENSettingSlideTableViewCell"
    
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescript: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    private var step:Float = 1
    
    var indexPath:IndexPath?
    weak var delegate: ENSettingSlideTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    
    func setValue(min:Float, max:Float, step:Float = 1, current:Float = 0) {
        self.step = step
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = current
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        if roundedValue != sender.value {
            sender.value = roundedValue
            delegate?.slideValueChanged(cell: self, newValue: roundedValue)
        }
    }
    
}
