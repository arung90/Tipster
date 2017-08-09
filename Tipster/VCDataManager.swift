import Foundation

class VCDataManager {
    
    func stringForTipAmount(_ tipAmount: Double, totalAmount: Double) -> (tipAmountString: String, totalAmountString: String)  {
        return (String(format: "$%.2f", tipAmount), String(format: "$%.2f", totalAmount))
    }
    
    func calculateTotalForAmount(_ amount: Double, tipAmount: Double) -> Double {
        return amount + Double(tipAmount)
    }
    
    func calculateTipForAmount(_ amount: Double, tipPercent: Int) -> Double {
        let tipAmount = Double(tipPercent)/100 * amount
        return tipAmount
    }
}
