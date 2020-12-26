


import UIKit

//合計個数とそれぞれの個数を追加する
//カンマをつける
//.redのところは後でテーマカラーで変更できるようにする

class CalculationViewController: UIViewController {
    
    private var taxRate = 1.10 {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var priceLabelString = "" {
        didSet { tappedTaxRateOrTaxIncludeOrNotButton() }
    }
    private var toggleKeyboardFlag = true
    private let shoppingListCellId = "shoppingListCellId"
    private var shoppingListArray: [String] = [] {
        didSet {
            shoppingListCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var calculatorNavigationBar: UINavigationBar! {
        didSet { calculatorNavigationBar.barTintColor = .red }
    }
    @IBOutlet weak var calculatorTotalPriceView: UIView! {
        didSet { viewDesign(view: calculatorTotalPriceView, shadowHeight: 2) }
    }
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var includeTaxLabel: UILabel!
    @IBOutlet weak var shoppingListCollectionView: UICollectionView! {
        didSet {
            shoppingListCollectionView.register(UINib(nibName: "ShoppingListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: shoppingListCellId)
            shoppingListCollectionView.delegate = self
            shoppingListCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var calculatorPriceView: UIView! {
        didSet { viewDesign(view: calculatorPriceView, shadowHeight: -2) }
    }
    @IBOutlet weak var calculatorView: UIView! {
        didSet {
            calculatorView.backgroundColor = .red
            calculatorView.layer.borderWidth = 2
            calculatorView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var taxRateButton: UIButton! {
        didSet {
            taxRateButton.backgroundColor = .red
            taxRateButton.layer.borderWidth = 2
            taxRateButton.layer.borderColor = UIColor.white.cgColor
            taxRateButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var taxIncludeOrNotButton: UIButton! {
        didSet {
            taxIncludeOrNotButton.backgroundColor = .red
            taxIncludeOrNotButton.layer.borderWidth = 2
            taxIncludeOrNotButton.layer.borderColor = UIColor.white.cgColor
            taxIncludeOrNotButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var taxIncludePriceLabel: UILabel!
    @IBOutlet weak var taxIncludeTaxRateLabel: UILabel!
    @IBOutlet weak var calculator0Button: UIButton! {
        didSet { buttonDesign(button: calculator0Button) }
    }
    @IBOutlet weak var calculator1Button: UIButton! {
        didSet { buttonDesign(button: calculator1Button) }
    }
    @IBOutlet weak var calculator2Button: UIButton! {
        didSet { buttonDesign(button: calculator2Button) }
    }
    @IBOutlet weak var calculator3Button: UIButton! {
        didSet { buttonDesign(button: calculator3Button) }
    }
    @IBOutlet weak var calculator4Button: UIButton! {
        didSet { buttonDesign(button: calculator4Button) }
    }
    @IBOutlet weak var calculator5Button: UIButton! {
        didSet { buttonDesign(button: calculator5Button) }
    }
    @IBOutlet weak var calculator6Button: UIButton! {
        didSet { buttonDesign(button: calculator6Button) }
    }
    @IBOutlet weak var calculator7Button: UIButton! {
        didSet { buttonDesign(button: calculator7Button) }
    }
    @IBOutlet weak var calculator8Button: UIButton! {
        didSet { buttonDesign(button: calculator8Button) }
    }
    @IBOutlet weak var calculator9Button: UIButton! {
        didSet { buttonDesign(button: calculator9Button) }
    }
    @IBOutlet weak var calculatorAddButton: UIButton! {
        didSet { buttonDesign(button: calculatorAddButton) }
    }
    @IBOutlet weak var calculatorClearButton: UIButton! {
        didSet { buttonDesign(button: calculatorClearButton) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        taxIncludePriceLabel.text = ""
        taxIncludeTaxRateLabel.text = ""
        collectionViewFlowLayout()
    }
    
    private func collectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemSize = shoppingListCollectionView.frame.size.width / 3 - 20
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        shoppingListCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func clearAll(_ sender: Any) {
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
    
    @IBAction func tappedCalculator0Button(_ sender: Any) {
        if priceLabelString != "" {
            reflectToLabel(button: calculator0Button)
        }
    }
    
    @IBAction func tappedCalculator1Button(_ sender: Any) {
        reflectToLabel(button: calculator1Button)
    }
    
    @IBAction func tappedCalculator2Button(_ sender: Any) {
        reflectToLabel(button: calculator2Button)
    }
    
    @IBAction func tappedCalculator3Button(_ sender: Any) {
        reflectToLabel(button: calculator3Button)
    }
    
    @IBAction func tappedCalculator4Button(_ sender: Any) {
        reflectToLabel(button: calculator4Button)
    }
    
    @IBAction func tappedCalculator5Button(_ sender: Any) {
        reflectToLabel(button: calculator5Button)
    }
    
    @IBAction func tappedCalculator6Button(_ sender: Any) {
        reflectToLabel(button: calculator6Button)
    }
    
    @IBAction func tappedCalculator7Button(_ sender: Any) {
        reflectToLabel(button: calculator7Button)
    }
    
    @IBAction func tappedCalculator8Button(_ sender: Any) {
        reflectToLabel(button: calculator8Button)
    }
    
    @IBAction func tappedCalculator9Button(_ sender: Any) {
        reflectToLabel(button: calculator9Button)
    }
    
    private func reflectToLabel(button: UIButton) {
        priceLabelString += button.currentTitle!
        priceLabel.text = priceLabelString
        
    }
    
    private func tappedTaxRateOrTaxIncludeOrNotButton() {
        guard let  priceLabelDouble = Double(priceLabelString) else { return }
        let includeTaxPrice = priceLabelDouble * taxRate
        if taxIncludeOrNotButton.currentTitle == "税抜" {
            taxIncludePriceLabel.text = "税込 \(Int(includeTaxPrice))円"
        }
    }
    
    @IBAction func tappedCalculatorAddButton(_ sender: Any) {
        if taxIncludeOrNotButton.currentTitle == "税込" {
            shoppingListArray.append(priceLabelString)
        }else {
            guard let  priceLabelDouble = Double(priceLabelString) else { return }
            let includeTaxPrice = Int(floor(priceLabelDouble * taxRate))
            shoppingListArray.append(String(includeTaxPrice))
        }
        clearLabel()
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
    
    private func viewDesign(view: UIView, shadowHeight: Int) {
        view.backgroundColor = .red
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: shadowHeight)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.8
    }
    
    private func buttonDesign(button: UIButton) {
        button.backgroundColor = .red
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    }
}

extension CalculationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shoppingListCollectionView.dequeueReusableCell(withReuseIdentifier: shoppingListCellId, for: indexPath) as! ShoppingListCollectionViewCell
        let itemSize = shoppingListCollectionView.frame.size.width / 3 - 20
        cell.setupCell(cellSize: itemSize) 
        return cell
    }
    
    
    
}
