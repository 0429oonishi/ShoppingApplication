
import UIKit

// MARK: - todo それぞれの個数を追加する
// MARK: - todo collectionでの操作も追加する

class CalculationViewController: UIViewController {
    
    private var taxRate = 1.10 {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var priceLabelString = "" {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var toggleKeyboardFlag = true
    private let shoppingListCellId = "shoppingListCellId"
    private var shoppingListPriceArray: [String] = [] {
        didSet {
            shoppingListCollectionView.reloadData()
            if shoppingListPriceArray.count == 0 {
                calculationRemainCountLabel.text = ""
            }else {
                calculationRemainCountLabel.text = "合計\(shoppingListPriceArray.count)個"
            }
        }
    }
    private var shoppingListTaxRateArray: [String] = []
    private var shoppingListTaxIncludeOrNotArray: [String] = []
    private var totalPriceLabelString = ""
    private var totalPriceLabelInt = 0
    private var totalPriceTaxSumDouble = 0.0
    private var totalPriceTaxDouble: Double = 0.0 {
        didSet {
            totalPriceTaxSumDouble += totalPriceTaxDouble
            let totalPriceTaxCommaString = addComma(String(Int(totalPriceTaxSumDouble)))
            includeTaxLabel.text = "内消費税\(totalPriceTaxCommaString)円"
        }
    }
    private var themeColor: UIColor {
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            return UIColor(code: themeColorString)
        }else {
            return .white
        }
    }
    private var borderColor: UIColor {
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            return UIColor(code: themeColorString)
        }else {
            return .black
        }
    }

    @IBOutlet weak var calculationRemainCountLabel: UILabel!
    @IBOutlet weak var calculatorNavigationBar: UINavigationBar!
    @IBOutlet weak var calculatorTotalPriceView: UIView! {
        didSet { viewDesign(view: calculatorTotalPriceView, shadowHeight: 2) }
    }
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var includeTaxLabel: UILabel!
    @IBOutlet weak var shoppingListCollectionView: UICollectionView! {
        didSet {
            let nibName = UINib(nibName: "ShoppingListCollectionViewCell", bundle: nil)
            shoppingListCollectionView.register(nibName, forCellWithReuseIdentifier: shoppingListCellId)
            shoppingListCollectionView.delegate = self
            shoppingListCollectionView.dataSource = self
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
    @IBOutlet var calculatorButton: [UIButton]!  {
        didSet {
            for n in 0...9 {
                buttonDesign(button: calculatorButton[n])
            }
        }
    }
    @IBOutlet weak var calculatorAddButton: UIButton! {
        didSet { buttonDesign(button: calculatorAddButton) }
    }
    @IBOutlet weak var calculatorClearButton: UIButton! {
        didSet { buttonDesign(button:
                                calculatorClearButton) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taxIncludePriceLabel.text = ""
        taxIncludeTaxRateLabel.text = ""
        collectionViewFlowLayout()
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
        for n in 0...9 {
            calculatorButton[n].backgroundColor = themeColor
        }
        calculatorAddButton.backgroundColor = themeColor
        calculatorClearButton.backgroundColor = themeColor
        shoppingListCollectionView.reloadData()
    }
    
    private func collectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemSize = shoppingListCollectionView.frame.size.width / 3 - 20
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        shoppingListCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func clearAll(_ sender: Any) {
        shoppingListPriceArray.removeAll()
        shoppingListTaxIncludeOrNotArray.removeAll()
        shoppingListTaxRateArray.removeAll()
        totalPriceLabel.text = "0円"
        includeTaxLabel.text = "内消費税0円"
        totalPriceLabelInt = 0
        totalPriceTaxSumDouble = 0
        clearLabel()
    }
    
    @IBAction func toggleKeyboard(_ sender: Any) {
        if toggleKeyboardFlag {
            UIView.animate(withDuration: 0.15) {
                let distance = self.view.frame.maxY - self.calculatorPriceView.frame.minY
                self.calculatorPriceView.transform = CGAffineTransform(translationX: 0, y: distance)
                self.calculatorView.transform = CGAffineTransform(translationX: 0, y: distance)
            }
        }else {
            UIView.animate(withDuration: 0.15) {
                self.calculatorPriceView.transform = .identity
                self.calculatorView.transform = .identity
            }
        }
        toggleKeyboardFlag = !toggleKeyboardFlag
    }
    
    @IBAction func tappedTaxRateButton(_ sender: Any) {
        if taxRateButton.currentTitle == "10%" {
            taxRateButton.setTitle("8%", for: .normal)
            if taxIncludeOrNotButton.currentTitle == "税抜" {
                taxIncludeTaxRateLabel.text = "(8%)"
            }
            taxRate = 1.08
        }else {
            taxRateButton.setTitle("10%", for: .normal)
            if taxIncludeOrNotButton.currentTitle == "税抜" {
                taxIncludeTaxRateLabel.text = "(10%)"
            }
            taxRate = 1.10
        }
    }
    
    @IBAction func tappedTaxIncludeOrNotButton(_ sender: Any) {
        if taxIncludeOrNotButton.currentTitle == "税込" {
            taxIncludeOrNotButton.setTitle("税抜", for: .normal)
            if priceLabelString == "" {
                taxIncludePriceLabel.text = "税込 0円"
            }else {
                tappedTaxRateOrTaxIncludeOrNotButton()
            }
            if taxRate == 1.10 {
                taxIncludeTaxRateLabel.text = "(10%)"
            }else {
                taxIncludeTaxRateLabel.text = "(8%)"
            }
        }else {
            taxIncludeOrNotButton.setTitle("税込", for: .normal)
            taxIncludePriceLabel.text = ""
            taxIncludeTaxRateLabel.text = ""
        }
    }
    
    @IBAction func tappedCalculatorButton(_ sender: UIButton) {
        guard let button = calculatorButton else { return }
        let priceMaxCount = priceLabelString.count + 1
        if priceMaxCount > 6 {
            let alert = UIAlertController(title: "エラー", message: "金額が大きすぎます", preferredStyle: .actionSheet)
            let closeAction = UIAlertAction(title: "閉じる", style: .default) { (_) in
                self.clearLabel()
            }
            alert.addAction(closeAction)
            present(alert, animated: true)
            return
        }
        reflectToLabel(button: button[sender.tag])
    }
    
    private func reflectToLabel(button: UIButton) {
        priceLabelString += button.currentTitle!
        priceLabel.text = addComma(priceLabelString)
    }
    
    private func tappedTaxRateOrTaxIncludeOrNotButton() {
        guard let  priceLabelDouble = Double(priceLabelString) else { return }
        if taxIncludeOrNotButton.currentTitle == "税抜" {
            let includeTaxPrice = priceLabelDouble * taxRate
            var includeTaxPriceString = String(Int(includeTaxPrice))
            includeTaxPriceString = addComma(includeTaxPriceString)
            taxIncludePriceLabel.text = "税込 \(includeTaxPriceString)点"
        }
    }
    
    @IBAction func tappedCalculatorAddButton(_ sender: Any) {
        if priceLabelString != "" {
            if taxIncludeOrNotButton.currentTitle == "税込" {
                shoppingListPriceArray.append(priceLabelString)
                shoppingListTaxIncludeOrNotArray.append("税込")
            }else {
                guard let  priceLabelDouble = Double(priceLabelString) else { return }
                let includeTaxPrice = Int(floor(priceLabelDouble * taxRate))
                shoppingListPriceArray.append(String(includeTaxPrice))
                shoppingListTaxIncludeOrNotArray.append("税抜")
            }
            
            if taxRateButton.currentTitle == "10%" {
                shoppingListTaxRateArray.append("10%")
            }else {
                shoppingListTaxRateArray.append("8%")
            }
            
            taxCalculation()
            
            totalPriceLabelInt += Int(shoppingListPriceArray.last!)!
            let priceLabelCommaString = addComma(String(totalPriceLabelInt))
            totalPriceLabel.text = "\(priceLabelCommaString)円"
            clearLabel()
        }
    }
    
    @IBAction func tappedCalculatorClearButton(_ sender: Any) {
        clearLabel()
    }
    
    private func clearLabel() {
        priceLabelString = ""
        priceLabel.text = "0"
        if taxIncludeOrNotButton.currentTitle == "税抜" {
            taxIncludePriceLabel.text = "税込 0円"
        }
    }
    
    private func taxCalculation() {
        let taxRateTitle = taxRateButton.currentTitle
        let includeTaxTitle = taxIncludeOrNotButton.currentTitle
        let priceLabelDouble = Double(priceLabelString)!
        if taxRateTitle == "10%" && includeTaxTitle == "税込" {
            totalPriceTaxDouble = priceLabelDouble * 10 / 110
        }else if taxRateTitle == "10%" && includeTaxTitle == "税抜" {
            totalPriceTaxDouble = priceLabelDouble * 10 / 100
        }else if taxRateTitle == "8%" && includeTaxTitle == "税込" {
            totalPriceTaxDouble = priceLabelDouble * 8 / 108
        }else if taxRateTitle == "8%" && includeTaxTitle == "税抜" {
            totalPriceTaxDouble = priceLabelDouble * 8 / 100
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
        button.layer.cornerRadius = button.frame.size.width/2
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
}

extension CalculationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingListPriceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shoppingListCollectionView.dequeueReusableCell(withReuseIdentifier: shoppingListCellId, for: indexPath) as! ShoppingListCollectionViewCell
        let shoppingListcommaPrice = addComma(shoppingListPriceArray[indexPath.row])
        cell.shoppingListLabel.text = "\(shoppingListcommaPrice)円"
        cell.shoppingListTaxRateButton.setTitle(shoppingListTaxRateArray[indexPath.row], for: .normal)
        cell.shoppingListIncludeTaxOrNotButton.setTitle(shoppingListTaxIncludeOrNotArray[indexPath.row], for: .normal)
        let itemSize = shoppingListCollectionView.frame.size.width / 3 - 20
        cell.setupCell(cellSize: itemSize)
        cell.layer.borderColor = borderColor.cgColor
        return cell
    }
}
