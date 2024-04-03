//
//  UIColor+ENKeyboardSDK+Theme.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/21.
//

import UIKit
import KeyboardSDKCore


extension UIColor {

    static var tabTitleNormal:UIColor       { return UIColor.init(named: "tabTitleNormal", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear       }
    static var tabTitleSelected:UIColor     { return UIColor.init(named: "tabTitleSelected", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear     }
    static var themeItemBorder:UIColor      { return UIColor.init(named: "themeItemBorder", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var titleLabel:UIColor           { return UIColor.init(named: "titleLabel", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear           }
    static var sortButtonNormal:UIColor     { return UIColor.init(named: "sortButtonNormal", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear     }
    static var sortButtonSelected:UIColor   { return UIColor.init(named: "sortButtonSelected", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear   }
    static var topButtonBorder:UIColor      { return UIColor.init(named: "topButtonBorder", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    
    
    static var aikbdBannerLineColor:UIColor     { return UIColor.init(named: "aikbdBannerLineColor", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear     }
    static var aikbdBasicTitleGray181:UIColor   { return UIColor.init(named: "aikbdBasicTitleGray181", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear   }
    static var aikbdBasicTitleGray201:UIColor   { return UIColor.init(named: "aikbdBasicTitleGray201", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear   }
    static var aikbdBodyLargeTitle:UIColor      { return UIColor.init(named: "aikbdBodyLargeTitle", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var aikbdBodySmallTitle:UIColor      { return UIColor.init(named: "aikbdBodySmallTitle", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var aikbdBtnBlue:UIColor             { return UIColor.init(named: "aikbdBtnBlue", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear             }
    static var aikbdCategoryBrown:UIColor       { return UIColor.init(named: "aikbdCategoryBrown", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear       }
    static var aikbdCategoryBlack:UIColor       { return UIColor.init(named: "aikbdCategoryBlack", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear       }
    static var aikbdCategoryBlue:UIColor        { return UIColor.init(named: "aikbdCategoryBlue", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear        }
    static var aikbdCategoryGreen:UIColor       { return UIColor.init(named: "aikbdCategoryGreen", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear       }
    static var aikbdCategoryOrange:UIColor      { return UIColor.init(named: "aikbdCategoryOrange", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var aikbdCategoryPink:UIColor        { return UIColor.init(named: "aikbdCategoryPink", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear        }
    static var aikbdCategoryRed:UIColor         { return UIColor.init(named: "aikbdCategoryRed", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear         }
    static var aikbdCategorySkyBlue:UIColor     { return UIColor.init(named: "aikbdCategorySkyBlue", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear     }
    static var aikbdCategoryViolet:UIColor      { return UIColor.init(named: "aikbdCategoryViolet", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var aikbdCategoryYellow:UIColor      { return UIColor.init(named: "aikbdCategoryYellow", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var aikbdDeactivateGrey:UIColor      { return UIColor.init(named: "aikbdDeactivateGrey", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    static var aikbdPointBlue:UIColor           { return UIColor.init(named: "aikbdPointBlue", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear           }
    static var aikbdRollingOn:UIColor           { return UIColor.init(named: "aikbdRollingOn", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear           }
    static var aikbdSearchBg:UIColor            { return UIColor.init(named: "aikbdSearchBg", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear            }
    static var aikbdSKeywords:UIColor           { return UIColor.init(named: "aikbdSKeywords", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear           }
    static var aikbdSubcolorPurple:UIColor      { return UIColor.init(named: "aikbdSubcolorPurple", in: Bundle.frameworkBundle, compatibleWith: nil) ?? .clear      }
    
    
    
    
    
    
    
    /// argb int 값을 전달받아 UIColor를 생성한다.
    /// - Parameters:
    ///   - alpha: 색상 alpha값. 0~255
    ///   - red: 색상 red값. 0~255
    ///   - green: 색상 green값. 0~255
    ///   - blue: 색상 blue값. 0~255
    convenience init(alpha:Int64, red: Int64, green: Int64, blue: Int64) {
        assert(alpha >= 0 && alpha <= 255, "Invalid Alpha component")
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    
    /// 16진수 argb값을 통해 UIColor를 생성한다.
    /// - Parameter argb: 16진수 argb값  0x00000000 ~ 0xFFFFFFFF
    convenience init(argb: Int64) {
        self.init(
            alpha: (argb >> 24) & 0xFF,
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF
        )
    }
    
    
    /// rgb int 값을 전달받아 UIColor를 생성한다.
    /// - Parameters:
    ///   - r: 색상 red값. 0~255
    ///   - g: 색상 green값. 0~255
    ///   - b: 색상 blue값. 0~255
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r:r, g:g, b:b, a:255)
    }
    
    /// rgba int 값을 전달받아 UIColor를 생성한다.
    /// - Parameters:
    ///   - r: 색상 red값. 0~255
    ///   - g: 색상 green값. 0~255
    ///   - b: 색상 blue값. 0~255
    ///   - a: 색상 alpha값. 0~255
    convenience init(r: Int, g: Int, b: Int, a:Int) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    
    /// 현재 색상값을 이용하여 이미지를 생성한다
    /// - Returns: 현재 색상값을 기반으로 만들어진 이미지를 반환한다.  실패시 nil을 반환한다.
    func toImage() -> UIImage? {
        
        let rect = CGRect.init(x:0, y:0, width:1, height:1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /// Hex String으로 전달받은 값을 이용하여 UIColor를 생성한다.
    /// - Parameter hexString: 색상값에 대응하는 Hex String. 3자리, 6자리, 8자리 값으로 입력이 가능하다.  ex) #FFF, #FFFFFF, #FFFFFFFF
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func isLight(threshold: Float = 0.6) -> Bool {
        let originalCGColor = self.cgColor
        
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return false
        }
        guard components.count >= 3 else {
            return false
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
