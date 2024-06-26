//
//  RandomColor.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import UIKit
public typealias Color = UIColor

private var colorDictionary: [Hue: ColorDefinition] = [
    .monochrome: ColorDefinition(hueRange: nil, lowerBounds: [(0,0), (100,0)]),
    .red: ColorDefinition(hueRange: (-26,18), lowerBounds: [(20,100), (30,92), (40,89), (50,85), (60,78), (70,70), (80,60), (90,55), (100,50)]),
    .orange: ColorDefinition(hueRange: (19,46), lowerBounds: [(20,100), (30,93), (40,88), (50,86), (60,85), (70,70), (100,70)]),
    .yellow: ColorDefinition(hueRange: (47,62), lowerBounds: [(25,100), (40,94), (50,89), (60,86), (70,84), (80,82), (90,80), (100,75)]),
    .green: ColorDefinition(hueRange: (63,178), lowerBounds: [(30,100), (40,90), (50,85), (60,81), (70,74), (80,64), (90,50), (100,40)]),
    .blue: ColorDefinition(hueRange: (179,257), lowerBounds: [(20,100), (30,86), (40,80), (50,74), (60,60), (70,52), (80,44), (90,39), (100,35)]),
    .purple: ColorDefinition(hueRange: (258, 282), lowerBounds: [(20,100), (30,87), (40,79), (50,70), (60,65), (70,59), (80,52), (90,45), (100,42)]),
    .pink: ColorDefinition(hueRange: (283, 334), lowerBounds: [(20,100), (30,90), (40,86), (60,84), (80,80), (90,75), (100,73)])
]

extension Hue {
    var range: Range {
        switch self {
        case .value(let value): return (value, value)
        case .random: return (0, 360)
        default:
            if let colorDefinition = colorDictionary[self] {
                return colorDefinition.hueRange ?? (0, 360)
            } else {
                assert(false, "Unrecgonized Hue enum: \(self).")
                return (0, 360)
            }
        }
    }
}

/**
Generate a single random color with some conditions.

- parameter hue:        Hue of target color. It will be the main property of the generated color. Default is .Random.
- parameter luminosity: Luminosity of target color. It will decide the brightness of generated color. Default is .Random.

- returns: A random color following input conditions. It will be a `UIColor` object for iOS target, and an `NSColor` object for OSX target.
*/
public func randomColor(hue: Hue = .random, luminosity: Luminosity = .random) -> Color {
    
    func random(in range: Range) -> Int {
        assert(range.max >= range.min, "Max in range should be greater than min")
        return Int(arc4random_uniform(UInt32(range.max - range.min))) + range.min
    }
    
    func getColorDefinition(hueValue: Int) -> ColorDefinition {
        var hueValue = hueValue
        
        if hueValue >= 334 && hueValue <= 360 {
            hueValue -= 360
        }
        
        let color = colorDictionary.values.filter({ (definition: ColorDefinition) -> Bool in
            if let hueRange = definition.hueRange {
                return hueValue >= hueRange.min && hueValue <= hueRange.max
            } else {
                return false
            }
        })
        
        assert(color.count == 1, "There should one and only one color satisfied the filter")
        return color.first!
    }
    
    func pickHue(_ hue: Hue) -> Int {
        var hueValue = random(in: hue.range)
        
        // Instead of storing red as two seperate ranges,
        // we group them, using negative numbers
        if hueValue < 0 {
            hueValue = hueValue + 360
        }
        return hueValue
    }
    
    func pickSaturation(color: ColorDefinition, hue: Hue, luminosity: Luminosity) -> Int {
        var color = color
        
        if luminosity == .random {
            return random(in: (0, 100))
        }
        
        if hue == .monochrome {
            return 0
        }
        
        let saturationRange = color.saturationRange
        var sMin = saturationRange.min
        var sMax = saturationRange.max
        
        switch luminosity {
        case .bright:
            sMin = 55
        case .dark:
            sMin = sMax - 10
        case .light:
            sMax = 55
        default: ()
        }
        
        return random(in: (sMin, sMax))
    }
    
    func pickBrightness(color: ColorDefinition, saturationValue: Int, luminosity: Luminosity) -> Int {
        let color = color
 
        func getMinimumBrightness(saturationValue: Int) -> Int {
            let lowerBounds = color.lowerBounds;
            for i in 0 ..< lowerBounds.count - 1 {
                
                let s1 = Float(lowerBounds[i].0)
                let v1 = Float(lowerBounds[i].1)
                
                let s2 = Float(lowerBounds[i+1].0)
                let v2 = Float(lowerBounds[i+1].1)
                
                if Float(saturationValue) >= s1 && Float(saturationValue) <= s2 {
                    let m = (v2 - v1) / (s2 - s1)
                    let b = v1 - m * s1
                    return lroundf(m * Float(saturationValue) + b)
                }
            }
            return 0
        }
        
        var bMin = getMinimumBrightness(saturationValue: saturationValue)
        var bMax = 100
        
        switch luminosity {
        case .dark:
            bMax = bMin + 20
        case .light:
            bMin = (bMax + bMin) / 2
        case .random:
            bMin = 0
            bMax = 100
        default: ()
        }
        
        return random(in: (bMin, bMax))
    }

    
    let hueValue = pickHue(hue)
    
    let color = getColorDefinition(hueValue: hueValue)
    
    let saturationValue = pickSaturation(color: color, hue: hue, luminosity: luminosity)
    let brightnessValue = pickBrightness(color: color, saturationValue: saturationValue, luminosity: luminosity)
    
    #if canImport(UIKit)
    return Color(hue: CGFloat(hueValue) / 360.0,
            saturation: CGFloat(saturationValue) / 100.0,
            brightness: CGFloat(brightnessValue) / 100.0,
                 alpha: 1.0)
    #else
    return Color(deviceHue: CGFloat(hueValue) / 360.0,
                saturation: CGFloat(saturationValue) / 100.0,
                brightness: CGFloat(brightnessValue) / 100.0,
                     alpha: 1.0)
    #endif
}

/**
Generate a set of random colors with some conditions.

- parameter count:      The count of how many colors will be generated.
- parameter hue:        Hue of target color. It will be the main property of the generated color. Default is .Random.
- parameter luminosity: Luminosity of target color. It will decide the brightness of generated color. Default is .Random.

- returns: An array of random colors following input conditions. The elements will be `UIColor` objects for iOS target, and `NSColor` objects for OSX target.
*/
public func randomColors(count: Int, hue: Hue = .random, luminosity: Luminosity = .random) -> [Color] {
    var colors: [Color] = []
    while (colors.count < count) {
        colors.append(randomColor(hue: hue, luminosity: luminosity))
    }
    return colors
}
typealias Range = (min: Int, max: Int)

struct ColorDefinition {
    let hueRange: Range?
    let lowerBounds: [Range]
    
    lazy var saturationRange: Range = {
        let sMin = self.lowerBounds[0].0
        let sMax = self.lowerBounds[self.lowerBounds.count - 1].0
        return (sMin, sMax)
    }()
    
    lazy var brightnessRange: Range = {
        let bMin = self.lowerBounds[self.lowerBounds.count - 1].1
        let bMax = self.lowerBounds[0].1
        return (bMin, bMax)
    }()
    
    init(hueRange: Range?, lowerBounds: [Range]) {
        self.hueRange = hueRange
        self.lowerBounds = lowerBounds
    }
}

public enum Luminosity: Int {
    case bright, light, dark
    case random
}

public enum Hue {
    
    case monochrome, red, orange, yellow, green, blue, purple, pink
    case value(Int)
    case random

    public func toInt() -> Int {
        switch self {
        case .monochrome: return 1
        case .red: return 2
        case .orange: return 3
        case .yellow: return 4
        case .green: return 5
        case .blue: return 6
        case .purple: return 7
        case .pink: return 8
        case .value(_): return -1
        case .random: return 0
        }
    }
}

public func == (lhs: Hue, rhs: Hue) -> Bool {
    return lhs.toInt() == rhs.toInt()
}

extension Hue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.toInt())
    }
}
