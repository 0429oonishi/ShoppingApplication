
import UIKit
import RealmSwift

final class CalculationViewController: UIViewController {
    
    private enum Tax: String {
        case taxIncluded = "税込"
        case taxExcluded = "税抜"
    }
    private enum TaxRate: String {
        case ten = "10%"
        case eight = "8%"
    }
    private var totalPriceToken: NotificationToken!
    private var totalNumberToken: NotificationToken!
    private var totalPriceDouble: Double = 0.0
    private var objects: Results<Calculation>!
    private var realm = try! Realm()
    private var calculation = Calculation()
    private var taxRate = 1.10 {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var priceLabelString = "" {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var toggleKeyboardFlag = true
    private let CELL_ID = String(describing: ShoppingListCollectionViewCell.self)
    private let CELL_NIB_NAME = String(describing: ShoppingListCollectionViewCell.self)
    private let budgetKey = "budgetKey"
    private var pickerCompo1 = 0
    private var pickerCompo2 = 0
    private var pickerCompo3 = 0
    private var pickerCompo4 = 0
    private var pickerCompo5 = 0
    private var itemSize: CGFloat {
        (UIScreen.main.bounds.width - 15 * 4 ) / 3
    }
    private var budgetPickerArray = [Int](0...9)
    private var totalPriceLabelInt = 0
    private var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .white
        }
        return UIColor(code: themeColorString)
    }
    private var borderColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .black
        }
        return UIColor(code: themeColorString)
    }
    
    @IBOutlet weak var calculationRemainCountLabel: UILabel!
    @IBOutlet weak var calculatorNavigationBar: UINavigationBar!
    @IBOutlet weak var calculatorTotalPriceView: UIView! {
        didSet { viewDesign(view: calculatorTotalPriceView, shadowHeight: 2) }
    }
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var shoppingListCollectionView: UICollectionView! {
        didSet {
            let nibName = UINib(nibName: CELL_NIB_NAME, bundle: nil)
            shoppingListCollectionView.register(nibName, forCellWithReuseIdentifier: CELL_ID)
            shoppingListCollectionView.delegate = self
            shoppingListCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var budgetPickerView: UIPickerView! {
        didSet { budgetPickerView.delegate = self }
    }
    @IBOutlet weak var budgetView: UIView! {
        didSet {
            budgetView.transform = CGAffineTransform(translationX: 0, y: -1000)
            budgetView.backgroundColor = .white
            budgetView.layer.borderWidth = 3
            budgetView.layer.cornerRadius = 30
            budgetView.layer.shadowOpacity = 0.8
            budgetView.layer.shadowRadius = 5
            budgetView.layer.shadowOffset = CGSize(width: 2, height: 2)
            budgetView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var budgetButton: UIBarButtonItem! {
        didSet {
            let budgetInt = UserDefaults.standard.integer(forKey: budgetKey)
            if budgetInt == 0 {
                budgetButton.title = "予算"
            }else {
                budgetButton.title = "\(addComma(String(budgetInt)))円"
            }
        }
    }
    
    @IBOutlet weak var calculatorPriceView: UIView! {
        didSet { viewDesign(view: calculatorPriceView, shadowHeight: -2) }
    }
    @IBOutlet weak var calculatorView: UIView! {
        didSet {
            calculatorView.layer.borderWidth = 2
            calculatorView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var taxRateButton: UIButton! {
        didSet {
            taxRateButton.layer.borderWidth = 2
            taxRateButton.layer.borderColor = UIColor.white.cgColor
            taxRateButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var taxIncludeOrNotButton: UIButton! {
        didSet {
            taxIncludeOrNotButton.layer.borderWidth = 2
            taxIncludeOrNotButton.layer.borderColor = UIColor.white.cgColor
            taxIncludeOrNotButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var taxIncludePriceLabel: UILabel!
    @IBOutlet weak var taxIncludeTaxRateLabel: UILabel!
    @IBOutlet var calculatorButton: [UIButton]!
    @IBOutlet var calculatorButtonView: [UIView]!
    @IBOutlet weak var discountView: UIView! {
        didSet {
            discountView.transform = CGAffineTransform(translationX: 1000, y: 0)
            discountView.layer.cornerRadius = 30
            discountView.layer.borderWidth = 3
            discountView.backgroundColor = .white
            discountView.layer.shadowColor = UIColor.black.cgColor
            discountView.layer.shadowRadius = 5
            discountView.layer.shadowOpacity = 0.8
            discountView.layer.shadowOffset = CGSize(width: 3, height: 3)
            
        }
    }
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountSlider: UISlider! {
        didSet {
            discountSlider.layer.borderWidth = 2
            discountSlider.layer.borderColor = UIColor.black.cgColor
        }
    }
    private var discountTappedButtonTag = 0
    private var discountSelectedValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(Calculation.self)
        taxIncludePriceLabel.text = ""
        taxIncludeTaxRateLabel.text = ""
        collectionViewFlowLayout()
        shoppingListCollectionView.reloadData()
        calculateTotalPrice()
        calculateTotalNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = themeColor
        calculatorNavigationBar.barTintColor = themeColor
        calculatorView.backgroundColor = themeColor
        taxRateButton.backgroundColor = themeColor
        taxIncludeOrNotButton.backgroundColor = themeColor
        calculatorTotalPriceView.backgroundColor = themeColor
        calculatorPriceView.backgroundColor = themeColor
        discountView.layer.borderColor = themeColor.cgColor
        discountSlider.minimumTrackTintColor = themeColor
        budgetView.layer.borderColor = themeColor.cgColor
        
        for n in 0...11 {
            calculatorButton[n].backgroundColor = themeColor
            [calculatorButton[n].leadingAnchor.constraint(equalTo: calculatorButtonView[n].leadingAnchor, constant: 10),
             calculatorButton[n].trailingAnchor.constraint(equalTo: calculatorButtonView[n].trailingAnchor, constant: -10),
             calculatorButton[n].topAnchor.constraint(equalTo: calculatorButtonView[n].topAnchor, constant: 10),
             calculatorButton[n].bottomAnchor.constraint(equalTo: calculatorButtonView[n].bottomAnchor, constant: -10)
            ].forEach { $0.isActive = true }
            buttonDesign(button: calculatorButton[n])
        }
        shoppingListCollectionView.reloadData()
        
    }
    
    private func collectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        shoppingListCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func clearAll(_ sender: Any) {
        if objects.count != 0 {
            let alert = UIAlertController(title: "全て消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
            let alertDefaultAction = UIAlertAction(title: "消去する", style: .default) { (_) in
                try! self.realm.write {
                    let removeObjects = self.realm.objects(Calculation.self)
                    self.realm.delete(removeObjects)
                }
                self.shoppingListCollectionView.reloadData()
                self.clearLabel()
            }
            let alertCancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(alertDefaultAction)
            alert.addAction(alertCancelAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func toggleKeyboard(_ sender: Any) {
        UIView.animate(withDuration: 0.15) { [self] in
            if toggleKeyboardFlag {
                let distance = view.frame.maxY - calculatorPriceView.frame.minY
                calculatorPriceView.transform = CGAffineTransform(translationX: 0, y: distance)
                calculatorView.transform = CGAffineTransform(translationX: 0, y: distance)
            }else {
                calculatorPriceView.transform = .identity
                calculatorView.transform = .identity
            }
        }
        toggleKeyboardFlag = !toggleKeyboardFlag
    }
    
    @IBAction func tappedTaxRateButton(_ sender: Any) {
        if taxRateButton.currentTitle == TaxRate.ten.rawValue {
            taxRateButton.setTitle(TaxRate.eight.rawValue, for: .normal)
            if taxIncludeOrNotButton.currentTitle == Tax.taxExcluded.rawValue {
                taxIncludeTaxRateLabel.text = "(\(TaxRate.eight.rawValue))"
            }
            taxRate = 1.08
        }else {
            taxRateButton.setTitle(TaxRate.ten.rawValue, for: .normal)
            if taxIncludeOrNotButton.currentTitle == Tax.taxExcluded.rawValue {
                taxIncludeTaxRateLabel.text = "(\(TaxRate.ten.rawValue))"
            }
            taxRate = 1.10
        }
    }
    
    @IBAction func tappedTaxIncludeOrNotButton(_ sender: Any) {
        if taxIncludeOrNotButton.currentTitle == Tax.taxIncluded.rawValue {
            taxIncludeOrNotButton.setTitle(Tax.taxExcluded.rawValue, for: .normal)
            if priceLabelString == "" {
                taxIncludePriceLabel.text = "\(Tax.taxIncluded.rawValue) 0円"
            }else {
                tappedTaxRateOrTaxIncludeOrNotButton()
            }
            if taxRate == 1.10 {
                taxIncludeTaxRateLabel.text = "(\(TaxRate.ten.rawValue))"
            }else {
                taxIncludeTaxRateLabel.text = "(\(TaxRate.eight.rawValue))"
            }
        }else {
            taxIncludeOrNotButton.setTitle("\(Tax.taxIncluded.rawValue)", for: .normal)
            taxIncludePriceLabel.text = ""
            taxIncludeTaxRateLabel.text = ""
        }
    }
    
    @IBAction func tappedCalculatorButton(_ sender: UIButton) {
        guard let button = calculatorButton else { return }
        let priceMaxCount = priceLabelString.count + 1
        if priceMaxCount > 5 && UIScreen.main.bounds.width < 380 {
            priceLabel.font = .systemFont(ofSize: 20)
        }
        if priceMaxCount > 6 {
            let alert = UIAlertController(title: "エラー", message: "金額が大きすぎます", preferredStyle: .actionSheet)
            let closeAction = UIAlertAction(title: "閉じる", style: .default) { (_) in
                self.clearLabel()
            }
            alert.addAction(closeAction)
            present(alert, animated: true)
            return
        }
        if !(priceLabelString == "" && sender.tag == 0) {
            reflectToLabel(button: button[sender.tag])
        }
    }
    
    private func calculateTotalPrice() {
        totalPriceToken = objects.observe { [self] (notification) in
            totalPriceDouble = 0.0
            if objects.count != 0 {
                for n in 0...objects.count - 1 {
                    let totalPrice: Double = Double(objects[n].calculationPrice)!
                    let totalNumber: Double = Double(objects[n].shoppingListNumber)
                    let totalDiscount: Double = Double(objects[n].shoppingListDiscount)
                    totalPriceDouble += totalPrice * (1 - totalDiscount / 100) * totalNumber
                }
                totalPriceLabel.text = "\(addComma(String(Int(totalPriceDouble))))円"
            }else {
                totalPriceLabel.text = "0円"
            }
        }
    }
    
    private func calculateTotalNumber() {
        totalNumberToken = objects.observe { [self] (notification) in
            if objects.count != 0 {
                var totalNumber  = 0
                for n in 0...objects.count - 1 {
                    totalNumber += objects[n].shoppingListNumber
                }
                calculationRemainCountLabel.text = "(\(totalNumber)個)"
            }else {
                calculationRemainCountLabel.text = "(0個)"
            }
        }
    }
    
    
    private func reflectToLabel(button: UIButton) {
        priceLabelString += button.currentTitle!
        priceLabel.text = addComma(priceLabelString)
    }
    
    private func tappedTaxRateOrTaxIncludeOrNotButton() {
        guard let  priceLabelDouble = Double(priceLabelString) else { return }
        if taxIncludeOrNotButton.currentTitle == Tax.taxExcluded.rawValue {
            let includeTaxPrice = priceLabelDouble * taxRate
            var includeTaxPriceString = String(Int(includeTaxPrice))
            includeTaxPriceString = addComma(includeTaxPriceString)
            taxIncludePriceLabel.text = "\(Tax.taxIncluded.rawValue) \(includeTaxPriceString)円"
        }
    }
    
    @IBAction func tappedCalculatorAddButton(_ sender: Any) {
        if priceLabelString != "" {
            let calculation = Calculation()
            if taxIncludeOrNotButton.currentTitle == "\(Tax.taxIncluded.rawValue)" {
                calculation.calculationPrice = priceLabelString
            }else {
                guard let  priceLabelDouble = Double(priceLabelString) else { return }
                let includeTaxPrice = Int(floor(priceLabelDouble * taxRate))
                calculation.calculationPrice = String(includeTaxPrice)
            }
            try! realm.write {
                realm.add(calculation)
            }
            shoppingListCollectionView.reloadData()
            clearLabel()
        }
    }
    
    @IBAction func tappedBudgetButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [self] in
            budgetView.transform = .identity
            budgetView.transform = CGAffineTransform(translationX: 0, y: calculatorTotalPriceView.frame.maxY - budgetView.frame.maxY)
        }
    }
    
    @IBAction func tappedBudgetBackButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [self] in
            budgetView.transform = .identity
            budgetView.transform = CGAffineTransform(translationX: 0, y: -1000)
        }
    }
    
    @IBAction func tappedCalculatorClearButton(_ sender: Any) {
        clearLabel()
    }
    
    private func clearLabel() {
        priceLabelString = ""
        priceLabel.text = "0"
        priceLabel.font = .systemFont(ofSize: 25)
        if taxIncludeOrNotButton.currentTitle == Tax.taxExcluded.rawValue {
            taxIncludePriceLabel.text = "\(Tax.taxIncluded.rawValue) 0円"
        }
    }
    
    private func viewDesign(view: UIView, shadowHeight: Int) {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: shadowHeight)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.8
    }
    
    private func buttonDesign(button: UIButton) {
        let buttonWidth = (UIScreen.main.bounds.width - 80) / 4
        button.layer.cornerRadius = buttonWidth/2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    private func addComma(_ wantToAddCommaString: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        let commaPrice = numberFormatter.string(from: NSNumber(integerLiteral: Int(wantToAddCommaString)!)) ?? "\(wantToAddCommaString)"
        return commaPrice
    }
    
    @IBAction func tappedDiscountViewCloseButton(_ sender: Any) {
        discountSlider.value = 0
        discountLabel.text = "0%引き"
        UIView.animate(withDuration: 0.15) { [self] in
            switch Int.random(in: 1 ... 4) {
            case 1: discountView.transform = CGAffineTransform(translationX: 1000, y: 0)
            case 2: discountView.transform = CGAffineTransform(translationX: -1000, y: 0)
            case 3: discountView.transform = CGAffineTransform(translationX: 0, y: 1000)
            case 4: discountView.transform = CGAffineTransform(translationX: 0, y: -1000)
            default: return
            }
        }
        
        try! realm.write {
            objects[discountTappedButtonTag].shoppingListDiscount = discountSelectedValue
        }
        
        let discountFloatText = Float(objects[discountTappedButtonTag].shoppingListDiscount)
        discountSlider.setValue(discountFloatText, animated: true)
        discountLabel.text = "\(Int(discountFloatText))%引き"
        shoppingListCollectionView.reloadItems(at: [IndexPath(item: discountTappedButtonTag, section: 0)])
    }
    
    @IBAction func tappedDiscountSlider(_ sender: UISlider) {
        discountSelectedValue = Int(sender.value)
        discountLabel.text = "\(Int(sender.value))%引き"
    }
}

extension CalculationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shoppingListCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ShoppingListCollectionViewCell
        
        cell.setupCell(object: objects[indexPath.row])
        
        cell.shoppingListDeleteButton.addTarget(self, action: #selector(tappedShoppingListDeleteButton), for: .touchUpInside)
        cell.shoppingListDiscountButton.addTarget(self, action: #selector(tappedShoppingListDiscountButton), for: .touchUpInside)
        cell.shoppingListDeleteButton.tag = indexPath.row
        cell.shoppingListDiscountButton.tag = indexPath.row
        cell.shoppingListNumberDecreaseButton.tag = indexPath.row
        cell.shoppingListNumberIncreaseButton.tag = indexPath.row
        
        if objects[indexPath.row].shoppingListDiscount != 0 {
            cell.shoppingListDiscountButton.setTitle("-\(objects[indexPath.row].shoppingListDiscount)%", for: .normal)
        }else {
            cell.shoppingListDiscountButton.setTitle("割引", for: .normal)
        }
        return cell
    }
    
    @objc func tappedShoppingListDeleteButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "これを消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
        let alertDefaultAction = UIAlertAction(title: "消去する", style: .default) { (_) in
            try! self.realm.write {
                self.objects[sender.tag].calculationDeleteFlag = true
                let deletedObject = self.realm.objects(Calculation.self).filter("calculationDeleteFlag == true")
                self.realm.delete(deletedObject)
            }
            self.shoppingListCollectionView.reloadData()
        }
        let alertCancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertDefaultAction)
        alert.addAction(alertCancelAction)
        present(alert, animated: true)
    }
    
    @objc func tappedShoppingListDiscountButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.discountView.transform = .identity
        }
        discountTappedButtonTag = sender.tag
    }
    
}

extension CalculationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return budgetPickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .black
        label.text = budgetPickerArray[row].description
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: pickerCompo1 = budgetPickerArray[row]
        case 1: pickerCompo2 = budgetPickerArray[row]
        case 2: pickerCompo3 = budgetPickerArray[row]
        case 3: pickerCompo4 = budgetPickerArray[row]
        case 4: pickerCompo5 = budgetPickerArray[row]
        default: return
        }
        let budgetString = "\(pickerCompo1)" + "\(pickerCompo2)" + "\(pickerCompo3)" + "\(pickerCompo4)" + "\(pickerCompo5)"
        let budgetInt = Int(budgetString)!
        UserDefaults.standard.set(budgetInt, forKey: budgetKey)
        if budgetInt == 0 {
            budgetButton.title = "予算"
        }else {
            budgetButton.title = "\(addComma(String(budgetInt)))円"
        }
    }
}
