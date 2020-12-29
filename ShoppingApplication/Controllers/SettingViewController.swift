
import UIKit

class SettingViewController: UIViewController {
    
    private let sectionArray = ["一般", "サポート"]
    private let settingTableViewArray = [["テーマカラー変更"], ["このアプリを友達に紹介", "このアプリを評価", "ご意見、ご要望、不具合の報告"]]
    private let settingCellId = "settingCellId"
    private let borderWidth: CGFloat = 2
    private let cellHeight: CGFloat = 100
    @IBOutlet weak var settingNavigationBar: UINavigationBar! {
        didSet { settingNavigationBar.barTintColor = .red }
    }
    @IBOutlet weak var settingTableView: UITableView! {
        didSet {
            settingTableView.delegate = self
            settingTableView.dataSource = self
            settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: settingCellId)
            settingTableView.tableFooterView = UIView()
            settingTableView.isScrollEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTableViewArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath) as! SettingTableViewCell
        cell.settingTitleLabel.text = settingTableViewArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0, 0] {
            let themeColorViewController = storyboard?.instantiateViewController(identifier: "themeColorVCId") as! ThemeColorViewController
            themeColorViewController.modalPresentationStyle = .fullScreen
            present(themeColorViewController, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: settingTableView.frame.width, height: cellHeight))
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 60, width: 100, height: cellHeight - 60)
        label.text = sectionArray[section]
        label.textColor = .black
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = borderWidth
        label.layer.borderColor = UIColor.red.cgColor
        headerView.addSubview(label)
        let bottomBorder = CALayer()
        let bottomBorderX = label.frame.maxX + 20
        let bottomBorderY = label.frame.maxY - borderWidth
        let bottomBorderWidth = self.view.frame.size.width - bottomBorderX - 45
        bottomBorder.frame = CGRect(x: bottomBorderX, y: bottomBorderY, width: bottomBorderWidth, height: borderWidth)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        headerView.layer.addSublayer(bottomBorder)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight
    }
}

