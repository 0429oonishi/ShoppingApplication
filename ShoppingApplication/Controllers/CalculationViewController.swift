
import UIKit
import RealmSwift

final class CalculationViewController: UIViewController {
    
    private enum Tax {
        case included
        case excluded
        var text: String {
            switch self {
            case .included: return "税込"
            case .excluded: return "税抜"
            }
        }
        enum Rate {
            case ten
            case eight
            var text: String {
                switch self {
                case .ten: return "10%"
                case .eight: return "8%"
                }
            }
            var value: Double {
                switch self {
                case .ten: return 1.10
                case .eight: return 1.08
                }
            }
        }
    }
    private var taxRate: Tax.Rate = .ten {
        didSet { taxRateButtonOrTaxIncludeOrNotButtonDidTapped() }
    }
    private var priceLabelString = "" {
        didSet { taxRateButtonOrTaxIncludeOrNotButtonDidTapped() }
    }
    private let cellId = String(describing: ShoppingListCollectionViewCell.self)
    private var isCalculatorAppeared = true
    private var totalPriceToken: NotificationToken!
    private var totalNumberToken: NotificationToken!
    private var calculations: Results<Calculation> { CalculationRealmRepository.shared.calculations }
    private let budgetKey = "budgetKey"
    private var budgetPickerArray = [Int](0...9)
    private var pickerComponents = Array(repeating: 0, count: 5)
    private var discountButtonTag = 0
    private var discountValue = 0 {
        didSet { discountLabel.text = "\(discountValue)%引き" }
    }
    
    @IBOutlet weak private var remainCountLabel: UILabel!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    @IBOutlet weak private var totalPriceView: UIView! {
        didSet { viewDesign(view: totalPriceView, shadowHeight: 2) }
    }
    @IBOutlet weak private var totalPriceLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView! {
        didSet {
            let cellNibName = String(describing: ShoppingListCollectionViewCell.self)
            let nibName = UINib(nibName: cellNibName, bundle: nil)
            collectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        }
    }
    @IBOutlet weak private var budgetPickerView: UIPickerView!
    @IBOutlet weak private var budgetView: UIView! {
        didSet { viewDesign(view: budgetView, x: 0, y: -1000) }
    }
    @IBOutlet weak private var budgetButton: UIBarButtonItem! {
        didSet {
            let budgetInt = UserDefaults.standard.integer(forKey: budgetKey)
            budgetButton.title = (budgetInt == 0) ? "予算" : "\(String(budgetInt).commaFormated)円"
        }
    }
    @IBOutlet weak private var calculatorPriceView: UIView! {
        didSet { viewDesign(view: calculatorPriceView, shadowHeight: -2) }
    }
    @IBOutlet weak private var calculatorView: UIView! {
        didSet {
            calculatorView.layer.borderWidth = 2
            calculatorView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak private var taxRateButton: UIButton! {
        didSet {
            taxRateButton.layer.borderWidth = 2
            taxRateButton.layer.borderColor = UIColor.white.cgColor
            taxRateButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak private var taxIncludeOrNotButton: UIButton! {
        didSet {
            taxIncludeOrNotButton.layer.borderWidth = 2
            taxIncludeOrNotButton.layer.borderColor = UIColor.white.cgColor
            taxIncludeOrNotButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var taxIncludePriceLabel: UILabel!
    @IBOutlet weak private var taxIncludeTaxRateLabel: UILabel!
    @IBOutlet private var calculatorButtons: [UIButton]!
    @IBOutlet private var calculatorButtonViews: [UIView]!
    @IBOutlet weak private var discountView: UIView! {
        didSet { viewDesign(view: discountView, x: 1000, y: 0) } 
    }
    @IBOutlet weak private var discountLabel: UILabel!
    @IBOutlet weak private var discountSlider: UISlider! {
        didSet {
            discountSlider.layer.borderWidth = 2
            discountSlider.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        budgetPickerView.delegate = self
        
        taxIncludePriceLabel.text = ""
        taxIncludeTaxRateLabel.text = ""
        
        collectionViewFlowLayout()
        calculateTotalPrice()
        calculateTotalNumber()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupThemeColor()
        setupCalculatorButton()
        
        collectionView.reloadData()
        
    }
    
    @IBAction func clearAllButtonDidTapped(_ sender: Any) {
        if calculations.count != 0 {
            let alert = UIAlertController(title: "全て消去しますか？",
                                          message: "消去したものは元に戻せません。",
                                          preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: .delete, style: .default) { (_) in
                CalculationRealmRepository.shared.delete(self.calculations)
                self.collectionView.reloadData()
                self.clearLabel()
            }
            let cancelAction = UIAlertAction(title: .cancel, style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func toggleCalculatorButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.15) { [unowned self] in
            let distance = view.frame.maxY - calculatorPriceView.frame.minY
            calculatorPriceView.transform = isCalculatorAppeared ? CGAffineTransform(translationX: 0, y: distance) : .identity
            calculatorView.transform = isCalculatorAppeared ? CGAffineTransform(translationX: 0, y: distance) : .identity
        }
        isCalculatorAppeared = !isCalculatorAppeared
    }
    
    @IBAction func taxRateButtonDidTapped(_ sender: Any) {
        if taxRateButton.currentTitle == Tax.Rate.ten.text {
            taxRateButton.setTitle(Tax.Rate.eight.text, for: .normal)
            if taxIncludeOrNotButton.currentTitle == Tax.excluded.text {
                taxIncludeTaxRateLabel.text = "(\(Tax.Rate.eight.text))"
            }
            taxRate = .eight
        } else {
            taxRateButton.setTitle(Tax.Rate.ten.text, for: .normal)
            if taxIncludeOrNotButton.currentTitle == Tax.excluded.text {
                taxIncludeTaxRateLabel.text = "(\(Tax.Rate.ten.text))"
            }
            taxRate = .ten
        }
    }
    
    @IBAction func taxIncludeOrNotButtonDidTapped(_ sender: Any) {
        if taxIncludeOrNotButton.currentTitle == Tax.included.text {
            taxIncludeOrNotButton.setTitle(Tax.excluded.text, for: .normal)
            if priceLabelString == "" {
                taxIncludePriceLabel.text = "\(Tax.included.text) 0円"
            } else {
                taxRateButtonOrTaxIncludeOrNotButtonDidTapped()
            }
            taxIncludeTaxRateLabel.text = (taxRate == .ten) ? "(\(Tax.Rate.ten.text))" : "(\(Tax.Rate.eight.text))"
        } else {
            taxIncludeOrNotButton.setTitle(Tax.included.text, for: .normal)
            taxIncludePriceLabel.text = ""
            taxIncludeTaxRateLabel.text = ""
        }
    }
    
    @IBAction func calculatorButtonDidTapped(_ sender: UIButton) {
        guard let button = calculatorButtons else { return }
        let priceMaxCount = priceLabelString.count + 1
        if priceMaxCount > 5 && UIScreen.main.bounds.width < 380 {
            priceLabel.font = .systemFont(ofSize: 20)
        }
        if priceMaxCount > 6 {
            let alert = UIAlertController(title: "エラー",
                                          message: "金額が大きすぎます",
                                          preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: .close, style: .default) { (_) in
                self.clearLabel()
            }
            alert.addAction(defaultAction)
            present(alert, animated: true)
            return
        }
        if !(priceLabelString == "" && sender.tag == 0) {
            reflectToLabel(button: button[sender.tag])
        }
    }
    
    @IBAction func calculatorAddButtonDidTapped(_ sender: Any) {
        if priceLabelString != "" {
            let calculation = Calculation()
            guard let priceLabelDouble = Double(priceLabelString) else { return }
            let includeTaxPrice = Int(floor(priceLabelDouble * taxRate.value))
            calculation.price = (taxIncludeOrNotButton.currentTitle == Tax.included.text) ? priceLabelString : String(includeTaxPrice)
            CalculationRealmRepository.shared.add(calculation)
            collectionView.reloadData()
            clearLabel()
        }
    }
    
    @IBAction func calculatorClearButtonDidTapped(_ sender: Any) {
        clearLabel()
    }
    
    @IBAction func budgetButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            budgetView.transform = .identity
            budgetView.transform = CGAffineTransform(translationX: 0, y: totalPriceView.frame.maxY - budgetView.frame.maxY)
        }
    }
    
    @IBAction func budgetBackButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            budgetView.transform = .identity
            budgetView.transform = CGAffineTransform(translationX: 0, y: -1000)
        }
    }
    
    @IBAction func discountViewCloseButtonDidTapped(_ sender: Any) {
        discountSlider.value = 0
        UIView.animate(withDuration: 0.15) { [unowned self] in
            switch Int.random(in: 1 ... 4) {
            case 1: discountView.transform = CGAffineTransform(translationX: 1000, y: 0)
            case 2: discountView.transform = CGAffineTransform(translationX: -1000, y: 0)
            case 3: discountView.transform = CGAffineTransform(translationX: 0, y: 1000)
            case 4: discountView.transform = CGAffineTransform(translationX: 0, y: -1000)
            default: break
            }
        }
        
        CalculationRealmRepository.shared.update {
            calculations[discountButtonTag].shoppingListDiscount = discountValue
        }
        
        let discountFloatText = Float(calculations[discountButtonTag].shoppingListDiscount)
        discountSlider.setValue(discountFloatText, animated: true)
        discountValue = Int(discountFloatText)
        collectionView.reloadItems(at: [IndexPath(item: discountButtonTag, section: 0)])
    }
    
    @IBAction func discountSliderDidTapped(_ sender: UISlider) {
        discountValue = Int(sender.value)
    }
    
    private func setupThemeColor() {
        self.view.backgroundColor = UIColor.white.themeColor
        navigationBar.barTintColor = UIColor.white.themeColor
        calculatorView.backgroundColor = UIColor.white.themeColor
        taxRateButton.backgroundColor = UIColor.white.themeColor
        taxIncludeOrNotButton.backgroundColor = UIColor.white.themeColor
        totalPriceView.backgroundColor = UIColor.white.themeColor
        calculatorPriceView.backgroundColor = UIColor.white.themeColor
        discountView.layer.borderColor = UIColor.white.themeColor.cgColor
        discountSlider.minimumTrackTintColor = UIColor.white.themeColor
        budgetView.layer.borderColor = UIColor.white.themeColor.cgColor
    }
    
    private func setupCalculatorButton() {
        calculatorButtons.forEach { button in
            guard let superView = button.superview else { return }
            button.backgroundColor = UIColor.white.themeColor
            [button.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 10),
             button.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -10),
             button.topAnchor.constraint(equalTo: superView.topAnchor, constant: 10),
             button.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -10)
            ].forEach { $0.isActive = true }
            setButtonLayout(button: button)
        }
    }
    
    private func collectionViewFlowLayout() {
        // (画面サイズ - mergin * 4つ) / 一行のセルの数
        let itemSize = (UIScreen.main.bounds.width - 15 * 4 ) / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        collectionView.collectionViewLayout = layout
    }
    
    private func calculateTotalPrice() {
        totalPriceToken = calculations.observe { [unowned self] (_) in
            let totalPriceDouble = calculations.reduce(0.0) { (result, element) in
                let totalPrice = Double(element.price)!
                let totalNumber = Double(element.shoppingListCount)
                let totalDiscount = Double(element.shoppingListDiscount)
                return result + totalPrice * (1 - totalDiscount / 100) * totalNumber
            }
            totalPriceLabel.text = (calculations.count != 0) ? "\(String(Int(totalPriceDouble)).commaFormated)円" : "0円"
        }
    }
    
    private func calculateTotalNumber() {
        totalNumberToken = calculations.observe { [unowned self] (_) in
            let totalNumber = calculations.reduce(0) { $0 + $1.shoppingListCount }
            remainCountLabel.text = "(\(totalNumber)個)"
        }
    }
    
    private func reflectToLabel(button: UIButton) {
        priceLabelString += button.currentTitle!
        priceLabel.text = priceLabelString.commaFormated
    }
    
    private func clearLabel() {
        priceLabelString = ""
        priceLabel.text = "0"
        priceLabel.font = .systemFont(ofSize: 25)
        if taxIncludeOrNotButton.currentTitle == Tax.excluded.text {
            taxIncludePriceLabel.text = "\(Tax.included.text) 0円"
        }
    }
    
    private func taxRateButtonOrTaxIncludeOrNotButtonDidTapped() {
        guard let priceLabelDouble = Double(priceLabelString) else { return }
        if taxIncludeOrNotButton.currentTitle == Tax.excluded.text {
            let includeTaxPrice = priceLabelDouble * taxRate.value
            let includeTaxPriceString = String(Int(includeTaxPrice)).commaFormated
            taxIncludePriceLabel.text = "\(Tax.included.text) \(includeTaxPriceString)円"
        }
    }
    
}

extension CalculationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calculations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShoppingListCollectionViewCell
        let object = calculations[indexPath.row]
        cell.configure(object: object)
        cell.setTag(index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
}

extension CalculationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .black
        label.text = budgetPickerArray[row].description
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerComponents[component] = budgetPickerArray[row]
        let budgetString = pickerComponents.map { String($0) }.reduce("") { $0 + $1 }
        let budgetValue = Int(budgetString)!
        UserDefaults.standard.set(budgetValue, forKey: budgetKey)
        budgetButton.title = (budgetValue == 0) ? "予算" : "\(String(budgetValue).commaFormated)円"
    }
    
}

extension CalculationViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return budgetPickerArray.count
    }
    
}

extension CalculationViewController: ShoppingListCollectionViewCellDelegate {
    
    func deleteButtonDidTapped(_ tag: Int) {
        let alert = UIAlertController(title: "これを消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
        let alertDefaultAction = UIAlertAction(title: .delete, style: .destructive) { (_) in
            CalculationRealmRepository.shared.update {
                self.calculations[tag].isCalculationDeleted = true
            }
            let deletedObjects = CalculationRealmRepository.shared.filter("isCalculationDeleted == true")
            CalculationRealmRepository.shared.delete(deletedObjects)
            self.collectionView.reloadData()
        }
        let alertCancelAction = UIAlertAction(title: .cancel, style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertDefaultAction)
        alert.addAction(alertCancelAction)
        present(alert, animated: true)
    }
    
    func discountButtonDidTapped(_ tag: Int) {
        UIView.animate(withDuration: 0.1) {
            self.discountView.transform = .identity
        }
        discountButtonTag = tag
    }
}
