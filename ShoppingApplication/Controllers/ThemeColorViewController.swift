

import UIKit

class ThemeColorViewController: UIViewController {

    @IBOutlet weak var themeColorDecisionButton: UIButton!
    @IBOutlet weak var themeColorCollectionView: UICollectionView!
    private let themeColorCellId = "themeColorCellId"
    private let horizontalSpace = 40
    private var cellSize: Int { Int(self.view.bounds.width) / 3 - horizontalSpace }
    var themeColorArray: [UIColor] = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.862745098, green: 0.07843137255, blue: 0.2352941176, alpha: 1), #colorLiteral(red: 1, green: 0.4117647059, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 1, green: 0.07843137255, blue: 0.5764705882, alpha: 1), #colorLiteral(red: 1, green: 0.2705882353, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5490196078, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.9019607843, blue: 0.5490196078, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.168627451, blue: 0.8862745098, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0.4980392157, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.8784313725, blue: 0.8156862745, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0.5450980392, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        themeColorCollectionView.delegate = self
        themeColorCollectionView.dataSource = self
        themeColorCollectionView.register(UINib(nibName: "ThemeColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: themeColorCellId)
        
        themeColorCollectionViewLayout()
    }
    
    @IBAction func tappedThemeColorDecisionButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func themeColorCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        layout.minimumLineSpacing = 30
        themeColorCollectionView.collectionViewLayout = layout
    }
    
    
}

extension ThemeColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = themeColorCollectionView.dequeueReusableCell(withReuseIdentifier: themeColorCellId, for: indexPath) as! ThemeColorCollectionViewCell
        
        cell.layer.cornerRadius = CGFloat(cellSize/2)
        cell.backgroundColor = themeColorArray[indexPath.row]
        if indexPath.row == 0 {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.black.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
}
