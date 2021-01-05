
import UIKit
import RealmSwift

// MARK: - todo それぞれの個数を追加する
// MARK: - todo collectionでの操作も追加する
// MARK: - todo 消費税もrealm
// MARK: - todo 割引機能
// MARK: - todo 使い方をまるℹ︎で作る

class CalculationViewController: UIViewController {

    var objects: Results<Calculation>!
    var realm = try! Realm()
    var calculation = Calculation()
    private var taxRate = 1.10 {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var priceLabelString = "" {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var toggleKeyboardFlag = true
    private let shoppingListCellId = "shoppingListCellId"
    private let totalPriceTaxKey = "totalPriceTaxKey"
    private var itemSize: CGFloat {
        (UIScreen.main.bounds.width - 15 * 4 ) / 3
    }
    private var shoppingListTaxRateArray: [String] = []
    private var shoppingListTaxIncludeOrNotArray: [String] = []
    private var totalPriceLabelInt = 0
    private var totalPriceTaxSumDouble = 0.0
    private var totalPriceTaxDouble: Double = 0.0 {
        didSet {
            totalPriceTaxSumDouble += totalPriceTaxDouble
            UserDefaults.standard.set(totalPriceTaxSumDouble, forKey: totalPriceTaxKey)
            let totalPriceTaxCommaString = addComma(String(Int(totalPriceTaxSumDouble)))
            includeTaxLabel.text = "(内消費税\(totalPriceTaxCommaString)円)"
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
    @IBOutlet var calculatorButton: [UIButton]!
    @IBOutlet var calculatorButtonView: [UIView]!
    @IBOutlet weak var discountView: UIView! {
        didSet {
            self.discountView.transform = CGAffineTransform(translationX: 1000, y: 0)
        }
    }
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(Calculation.self)
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
        calcRemainCount()
        
        if objects.count != 0 {
            for n in 0...objects.count - 1 {
                totalPriceLabelInt += Int(objects[n].calculationPrice)!
            }
            totalPriceLabel.text = "\(addComma(String(totalPriceLabelInt)))円"
        }
        
        totalPriceLabelInt = 0
        if objects.count != 0 {
            for n in 0...objects.count - 1 {
                totalPriceLabelInt += Int(objects[n].calculationPrice)!
            }
        }
        
        totalPriceTaxDouble = UserDefaults.standard.double(forKey: totalPriceTaxKey)
        let totalPriceTaxCommaString = addComma(String(Int(totalPriceTaxDouble)))
        includeTaxLabel.text = "(内消費税\(totalPriceTaxCommaString)円)"

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
                self.totalPriceLabel.text = "0円"
                self.includeTaxLabel.text = "(内消費税0円)"
                self.totalPriceLabelInt = 0
                self.totalPriceTaxSumDouble = 0
                self.clearLabel()
                self.calcRemainCount()
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
            taxIncludePriceLabel.text = "税込 \(includeTaxPriceString)円"
        }
    }
    
    @IBAction func tappedCalculatorAddButton(_ sender: Any) {
        if priceLabelString != "" {
            let calculation = Calculation()
            if taxIncludeOrNotButton.currentTitle == "税込" {
                calculation.calculationPrice = priceLabelString
                shoppingListTaxIncludeOrNotArray.append("税込")
            }else {
                guard let  priceLabelDouble = Double(priceLabelString) else { return }
                let includeTaxPrice = Int(floor(priceLabelDouble * taxRate))
                shoppingListTaxIncludeOrNotArray.append("税抜")
                calculation.calculationPrice = String(includeTaxPrice)
            }
            shoppingListCollectionView.reloadData()
            
            if taxRateButton.currentTitle == "10%" {
                shoppingListTaxRateArray.append("10%")
            }else {
                shoppingListTaxRateArray.append("8%")
            }
            
            taxCalculation()
            
            try! realm.write {
                realm.add(calculation)
            }
            
            totalPriceLabelInt = 0
            for n in 0...objects.count - 1 {
                totalPriceLabelInt += Int(objects[n].calculationPrice)!
            }
            totalPriceLabel.text = "\(addComma(String(totalPriceLabelInt)))円"
            calcRemainCount()
            clearLabel()
        }
    }
    
    @IBAction func tappedCalculatorClearButton(_ sender: Any) {
        clearLabel()
    }
    
    private func clearLabel() {
        priceLabelString = ""
        priceLabel.text = "0"
        totalPriceLabelInt = 0
        priceLabel.font = .systemFont(ofSize: 25)
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
    
    private func calcRemainCount() {
        if objects.count == 0 {
            calculationRemainCountLabel.text = ""
        }else {
            calculationRemainCountLabel.text = "合計\(objects.count)個"
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
        if Int.random(in: 1 ... 4) == 1 {
            UIView.animate(withDuration: 0.15) {
                self.discountView.transform = CGAffineTransform(translationX: 1000, y: 0)
            }
        }else if Int.random(in: 1 ... 4) == 2 {
            UIView.animate(withDuration: 0.15) {
                self.discountView.transform = CGAffineTransform(translationX: -1000, y: 0)
            }
        }else if Int.random(in: 1 ... 4) == 3 {
            UIView.animate(withDuration: 0.15) {
                self.discountView.transform = CGAffineTransform(translationX: 0, y: 1000)
            }
        }else {
            UIView.animate(withDuration: 0.15) {
                self.discountView.transform = CGAffineTransform(translationX: 0, y: -1000)
            }
        }
        
       
        
    }
    
    @IBAction func tappedDiscountSlider(_ sender: UISlider) {
        discountLabel.text = "\(Int(sender.value))%引き"
    }
    
    
}

extension CalculationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shoppingListCollectionView.dequeueReusableCell(withReuseIdentifier: shoppingListCellId, for: indexPath) as! ShoppingListCollectionViewCell
        
        cell.indexPathRow = indexPath.row
        cell.setupCell(object: objects[indexPath.row])
        
        cell.shoppingListDeleteButton.addTarget(self, action: #selector(tappedShoppingListDeleteButton), for: .touchUpInside)
        cell.shoppingListDiscountButton.addTarget(self, action: #selector(tappedShoppingListDiscountButton), for: .touchUpInside)
        cell.shoppingListDeleteButton.tag = indexPath.row
        cell.shoppingListDiscountButton.tag = indexPath.row
        cell.shoppingListNumberDecreaseButton.tag = indexPath.row
        cell.shoppingListNumberIncreaseButton.tag = indexPath.row
 
        
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
    }

}
