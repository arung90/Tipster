import Foundation

enum Constant : String {
    case lastAmount = "last_Amount"
    case lastUseTime = "last_Use_Time"
    case hasDefaultTip = "has_Default_Tip"
    case hasCustomTip = "has_Custom_Tip"
    case defaultTip = "default_Tip_Percentage"
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
}
