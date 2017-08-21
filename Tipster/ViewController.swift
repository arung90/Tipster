import UIKit

enum PlaceHolder : String {
    case Tip = "Tip"
    case Total = "Total"
    case CustomTip = "Custom Tip"
}

//FIXME: DARK THEME
//FIXME: SETTINGS ICON
//FIXME: LAUNCH SCREEN
//FIXME: APP ICON
//FIXME: SERVICES

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tipAmountTextField: UITextField!
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var tipPercentSegment: UISegmentedControl!
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    let tipPercentArray = [15, 20, 25]
    let defaults = UserDefaults.standard
    let vcDataManager = VCDataManager()
    var isAppInUse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onApplicationWillEnterForeground(notification:)), name: .UIApplicationWillEnterForeground, object: nil)
        setUpView()
        amountTextField.delegate = self
        tapGestureRecognizer.addTarget(self, action: #selector(onSingleTap(_:)))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.setThemeColors(self, isDarkTheme: DataManager.isDarkThemeEnabled())
        
        if isAppInUse {
            amountTextField.text = DataManager.getLastAmount() > 0 ? String(DataManager.getLastAmount()) : ""
        } else {
            setLastAmountOnAppForeground()
        }
        
        setDefaultTip()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isAppInUse = true
        super.viewWillDisappear(animated)
        
        if let amountText = amountTextField.text, let amount = Double(amountText) {
            DataManager.setLastAmount(amount)
        }
    }
    
    func setUpView() {
        amountTextField.becomeFirstResponder()
        amountTextField.placeholder = DataManager.localeCurrencySymbol()
        tipAmountTextField.placeholder = PlaceHolder.Tip.rawValue
        totalAmountTextField.placeholder = PlaceHolder.Total.rawValue
        
        tipAmountTextField.isUserInteractionEnabled = false
        totalAmountTextField.isUserInteractionEnabled = false
    }
    
    func setDefaultTip() {
        let selectedTipPercent = DataManager.getDefaultTipPercent()
        if let index = tipPercentArray.index(of: selectedTipPercent) {
            tipPercentSegment.selectedSegmentIndex = index
        } else if DataManager.isCustomTipSet() {
            tipPercentSegment.setTitle(String(DataManager.getDefaultTipPercent()) + "%", forSegmentAt: tipPercentArray.count)
            tipPercentSegment.selectedSegmentIndex = tipPercentArray.count
        }
        userDidUpdate()
    }
    
    func setLastAmountOnAppForeground() {
        if DataManager.shouldUseLastAmount() && DataManager.getLastAmount() > 0 {
            amountTextField.text = String(DataManager.getLastAmount())
        } else {
            amountTextField.text = ""
        }
    }
    
    func onApplicationWillEnterForeground(notification: Notification) {
        isAppInUse = false
        setLastAmountOnAppForeground()
    }
    
    @IBAction func userDidChangeTipPercentage(_ sender: UISegmentedControl) {
        userDidUpdate()
    }
    
    @IBAction func onSingleTap(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            tappedView.endEditing(true)
        }
    }
    
    @IBAction func userDidEditAmount(_ sender: UITextField) {
        userDidUpdate()
    }
    
    
    func userDidUpdate() {
        let calculation = calculate()
        refreshAmountViewsWithTipAmount(calculation.tipAmount, totalAmount: calculation.totalAmount)
    }
    
    func refreshAmountViewsWithTipAmount(_ tipAmount: Double, totalAmount: Double) {
        let stringValues = vcDataManager.stringForTipAmount(tipAmount, totalAmount: totalAmount)
        tipAmountTextField.text = stringValues.tipAmountString
        totalAmountTextField.text = stringValues.totalAmountString
    }
    
    func getTipPercent() -> Int {
        let selectedIndex = tipPercentSegment.selectedSegmentIndex
        return selectedIndex >= tipPercentArray.count ? DataManager.getDefaultTipPercent() : tipPercentArray[selectedIndex]
    }
    
    func calculate() -> (tipAmount: Double, totalAmount: Double) {
        if let amountText = amountTextField.text, let amount = Double(amountText) {
            let tipAmount = vcDataManager.calculateTipForAmount(amount, tipPercent: getTipPercent())
            let totalAmount = vcDataManager.calculateTotalForAmount(amount, tipAmount: tipAmount)
            return (tipAmount, totalAmount)
        }
        return (0, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
