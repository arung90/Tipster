import UIKit

class SettingsViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var defaultTipSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var customTextField: UITextField!
    @IBOutlet weak var customTipPicker: UIPickerView!
    @IBOutlet weak var darkThemeSwitch: UISwitch!

    
    var tipPercentage = [15, 20, 25]
    let customTipArray = Array(stride(from: 30, through: 100, by: 5))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField.delegate = self
        customTipPicker.delegate = self
        setUpView()
        tapGestureRecognizer.addTarget(self, action: #selector(onSingleTap(_:)))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.setThemeColors(self, isDarkTheme: DataManager.isDarkThemeEnabled())
        setDefaultTip()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpView() {
        customTextField.placeholder = PlaceHolder.CustomTip.rawValue
        customTextField.isHidden = true
        customTipPicker.isHidden = true
        darkThemeSwitch.isOn = DataManager.isDarkThemeEnabled()
    }
    
    func isDefaultTipSet() -> Bool {
        return defaults.bool(forKey: Constant.hasDefaultTip.rawValue)
    }
    
    func isCustomTipSet() -> Bool {
        return defaults.bool(forKey: Constant.hasCustomTip.rawValue)
    }
    
    func getDefaultTipPercent() -> Int {
        return defaults.integer(forKey: Constant.defaultTip.rawValue)
    }
    
    func tipSegmentIndex() -> Int? {
        let selectedTipPercent = getDefaultTipPercent()
        return tipPercentage.index(of: selectedTipPercent)
    }
    
    func setDefaultTip() {
        if isCustomTipSet() {
            defaultTipSegmentControl.selectedSegmentIndex = tipPercentage.count
            customTextField.isHidden = false
            customTipPicker.isHidden = false
            customTextField.text = String(getDefaultTipPercent()) + "%"
        } else if isDefaultTipSet(), let segmentIndex = tipSegmentIndex()  {
            defaultTipSegmentControl.selectedSegmentIndex = segmentIndex
        } else {
            defaultTipSegmentControl.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func userDidSelectDefaultTip(_ sender: UISegmentedControl) {
        userDidSelectDefaultTip(selectedIndex: sender.selectedSegmentIndex)
    }
    
    @IBAction func userDidSwitchToDarkTheme(_ sender: UISwitch) {
        DataManager.setDarkThemeEnabled(sender.isOn)
        DataManager.setThemeColors(self, isDarkTheme: sender.isOn)
        customTipPicker.reloadAllComponents()
    }
    
    func userDidSelectDefaultTip(selectedIndex: Int) {
        if selectedIndex < tipPercentage.count {
            customTextField.isHidden = true
            customTipPicker.isHidden = true
            defaults.set(true, forKey: Constant.hasDefaultTip.rawValue)
            defaults.set(false, forKey: Constant.hasCustomTip.rawValue)
            defaults.set(tipPercentage[selectedIndex], forKey: Constant.defaultTip.rawValue)
            defaults.synchronize()
        } else {
            userDidSelectCustomTip()
        }
    }
    
    func userDidSelectCustomTip() {
        customTextField.isHidden = false
        customTextField.becomeFirstResponder()
    }
    
    @IBAction func onSingleTap(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            tappedView.endEditing(true)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        customTipPicker.isHidden = false
        customTextField.text = String(customTipArray[0])
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customTipArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.set(false, forKey: Constant.hasDefaultTip.rawValue)
        defaults.set(true, forKey: Constant.hasCustomTip.rawValue)
        defaults.set(customTipArray[row], forKey: Constant.defaultTip.rawValue)
        defaults.synchronize()
        customTextField.text = String(customTipArray[row]) + "%"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = String(customTipArray[row])
        let attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: DataManager.pickerTitleColor(forTheme: DataManager.isDarkThemeEnabled())])
        return attributedTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
