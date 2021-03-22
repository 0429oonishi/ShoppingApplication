
import UIKit

final class ThemeColorViewController: UIViewController {

    private let cellId = "themeColorCellId"
    
    @IBOutlet weak private var navigationBar: UINavigationBar! {
        didSet { navigationBar.tintColor = .black }
    }
    @IBOutlet weak private var decisionButton: UIBarButtonItem!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var adMobView: UIView!
    
    private let horizontalSpace = 40
    private var cellSize: Int { Int(self.view.bounds.width) / 3 - horizontalSpace }
    private var selectedColor: UIColor?
    private let themeColors: [UIColor] = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.862745098, green: 0.07843137255, blue: 0.2352941176, alpha: 1), #colorLiteral(red: 1, green: 0.07843137255, blue: 0.5764705882, alpha: 1), #colorLiteral(red: 1, green: 0.4117647059, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 1, green: 0.2705882353, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5490196078, blue: 0, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.9019607843, blue: 0.5490196078, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.168627451, blue: 0.8862745098, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0.4980392157, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.8784313725, blue: 0.8156862745, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0.5450980392, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeColorCollectionViewLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        AdMob.addAdMobView(adMobView: adMobView,
                           width: self.view.frame.size.width,
                           height: adMobView.frame.size.height,
                           viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            self.view.backgroundColor = UIColor(code: themeColorString)
            navigationBar.barTintColor = UIColor(code: themeColorString)
        }
        
    }
    
    @IBAction func tappedThemeColorDecisionButton(_ sender: Any) {
        if let themeSelectedColor = selectedColor {
            UserDefaults.standard.set(themeSelectedColor.rgbString, forKey: "themeColorKey")
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func themeColorCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        layout.minimumLineSpacing = 30
        collectionView.collectionViewLayout = layout
    }
    
}

extension ThemeColorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for n in 0..<themeColors.count {
            switch indexPath.row {
            case n: selectedColor = themeColors[n]
            default: break
            }
        }
        self.view.backgroundColor = selectedColor
        navigationBar.barTintColor = selectedColor
    }
    
}

extension ThemeColorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.layer.cornerRadius = CGFloat(cellSize/2)
        cell.backgroundColor = themeColors[indexPath.row]
        return cell
    }
    
}

extension ThemeColorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
}
