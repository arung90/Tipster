import Foundation
import UIKit

enum Constant : String {
    case lastAmount = "last_Amount"
    case lastUseTime = "last_Use_Time"
    case hasDefaultTip = "has_Default_Tip"
    case hasCustomTip = "has_Custom_Tip"
    case defaultTip = "default_Tip_Percentage"
    case darkThemeEnabled = "has_Dark_Theme_enabled"
}

enum ThemeColor {
    case backgroundColor
    case foregroundColor
    case segmentedControlColor
    case darkBackgroundColor
    case darkForegroundColor
    
    var value : UIColor {
        switch self {
        case .backgroundColor:
            return UIColor.white
        case .foregroundColor:
            return UIColor.black
        case .segmentedControlColor:
            return UIColor.blue
        case .darkBackgroundColor:
            return UIColor.black
        case .darkForegroundColor:
            return UIColor.yellow
        }
    }
}

class DataManager {
    
    static func isDefaultTipSet() -> Bool {
        return UserDefaults.standard.bool(forKey: Constant.hasDefaultTip.rawValue)
    }
    
    static func isCustomTipSet() -> Bool {
        return UserDefaults.standard.bool(forKey: Constant.hasCustomTip.rawValue)
    }
    
    static func getDefaultTipPercent() -> Int {
        return UserDefaults.standard.integer(forKey: Constant.defaultTip.rawValue)
    }
    
    static func setLastAmount(_ amount: Double) {
        UserDefaults.standard.set(amount, forKey: Constant.lastAmount.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getLastAmount() -> Double {
        return UserDefaults.standard.double(forKey: Constant.lastAmount.rawValue)
    }
    
    static func setLastUseTime() {
        UserDefaults.standard.set(Date(), forKey: Constant.lastUseTime.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getTimeSinceLastUse() -> Date {
        if let lastUsedDate = UserDefaults.standard.object(forKey: Constant.lastUseTime.rawValue) as? Date {
            return lastUsedDate
        } else {
            return Date()
        }
    }
    
    static func minutesSince(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
    }
    
    static func shouldUseLastAmount() -> Bool {
        return minutesSince(getTimeSinceLastUse()) < 1 ? true : false
    }
    
    static func setDarkThemeEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Constant.darkThemeEnabled.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func isDarkThemeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: Constant.darkThemeEnabled.rawValue)
    }
    
    static func localeCurrencySymbol() -> String {
        let theLocale = NSLocale.current
        if let currencySymbol = theLocale.currencySymbol {
            return currencySymbol
        } else {
            return "$"
        }
    }
    
    static func getColors(forTheme isDarkTheme: Bool) -> (fgColor: UIColor, bgColor: UIColor) {
        if isDarkTheme {
            return (ThemeColor.darkForegroundColor.value, ThemeColor.darkBackgroundColor.value)
        } else {
            return(ThemeColor.foregroundColor.value, ThemeColor.backgroundColor.value)
        }
        
    }
    
    static func setThemeColors(_ viewController: UIViewController, isDarkTheme: Bool) {
        
        let colors = getColors(forTheme: isDarkTheme)
        
        viewController.view.backgroundColor = colors.bgColor
        
        viewController.view.subviews.map(
            { if ($0 is UILabel) {
                if let label = $0 as? UILabel {
                    label.textColor = colors.fgColor
                }
            } else if ($0 is UITextField) {
                if let textField = $0 as? UITextField {
                    textField.textColor = colors.fgColor
                }
            } else if ($0 is UISegmentedControl) {
                if let segmentedControl = $0 as? UISegmentedControl {
                    segmentedControl.tintColor = colors.fgColor
                    segmentedControl.backgroundColor = colors.bgColor
                }
                }
        })
        
        viewController.navigationController?.navigationBar.tintColor = colors.fgColor
        viewController.navigationController?.navigationBar.backgroundColor = colors.bgColor
    }
    
    static func pickerTitleColor(forTheme isDarkTheme: Bool) -> UIColor {
        return getColors(forTheme: isDarkTheme).fgColor
    }
    
}
