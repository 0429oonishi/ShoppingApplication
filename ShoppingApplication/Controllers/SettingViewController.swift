
import UIKit
import StoreKit
import GoogleMobileAds

class SettingViewController: UIViewController {
    
    private let sectionArray = ["一般", "サポート"]
    private let settingTableViewArray = [["テーマカラー変更"], ["このアプリを友達に紹介", "このアプリを評価", "ご意見、ご要望、不具合の報告"]]
    private let settingCellId = "settingCellId"
    private let borderWidth: CGFloat = 2
    private var cellHeight: CGFloat = 90
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
    @IBOutlet weak var settingNavigationBar: UINavigationBar!
    @IBOutlet weak var settingTableView: UITableView! {
        didSet {
            settingTableView.delegate = self
            settingTableView.dataSource = self
            settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: settingCellId)
            settingTableView.tableFooterView = UIView()
            settingTableView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var adMobView: UIView!
    
    private let adMobId = "ca-app-pub-5791981660348332/8471327283"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAdMobView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.view.backgroundColor = themeColor
            settingNavigationBar.barTintColor = themeColor
            settingTableView.reloadData()
    }
    
    private func addAdMobView() {
        var AdMobView = GADBannerView()
        AdMobView = GADBannerView(adSize: kGADAdSizeBanner)
        AdMobView.frame.size = CGSize(width: self.view.frame.size.width, height: adMobView.frame.size.height)
        AdMobView.adUnitID = adMobId
        AdMobView.rootViewController = self
        AdMobView.load(GADRequest())
        adMobView.addSubview(AdMobView)
    }
    
    private func transitionToThemeColorVC() {
        let themeColorViewController = storyboard?.instantiateViewController(identifier: "themeColorVCId") as! ThemeColorViewController
        themeColorViewController.modalPresentationStyle = .fullScreen
        present(themeColorViewController, animated: true)
    }
    
    private func introduceAppToFriend() {
        let shareText = "おすすめのお買い物アプリです！\n買うものチェックリストや合計金額をお会計の前に計算できる計算機、お店を探せるマップが一つのアプリで完結します！\n「お買い物アプリ - MyCal(マイカル)」"
        let shareURL = URL(string: "https://itunes.apple.com/jp/app/id1548230056?mt=8")!
        let activityItems = [shareText, shareURL] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func evaluateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    private func reportAboutApp() {
        guard let reportURL = URL(string: "https://docs.google.com/forms/d/1qFKDnISWjCZ8QyBpsGMaNX-wSQRw30NIJU5TQqUpsro/edit") else { return }
        if UIApplication.shared.canOpenURL(reportURL) {
            UIApplication.shared.open(reportURL as URL)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTableViewArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath) as! SettingTableViewCell
        cell.settingTitleLabel.text = settingTableViewArray[indexPath.section][indexPath.row]
        cell.settingSeparatorView.backgroundColor = borderColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]:
            transitionToThemeColorVC()
        case [1, 0]:
            introduceAppToFriend()
        case [1, 1]:
            evaluateApp()
        case [1, 2]:
            reportAboutApp()
        default:
            break
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
        if section == 0 {
            label.frame = CGRect(x: 20, y: 20 - borderWidth, width: 100, height: 40)
        }else {
            label.frame = CGRect(x: 20, y: 50 - borderWidth, width: 100, height: 40)
        }
        label.text = sectionArray[section]
        label.textColor = .black
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = borderWidth
        label.layer.borderColor = borderColor.cgColor
        headerView.addSubview(label)
        let bottomBorder = CALayer()
        let bottomBorderX = label.frame.maxX + 20
        let bottomBorderY = label.frame.maxY - borderWidth
        let bottomBorderWidth = self.view.frame.size.width - bottomBorderX - 30
        bottomBorder.frame = CGRect(x: bottomBorderX, y: bottomBorderY, width: bottomBorderWidth, height: borderWidth)
        bottomBorder.backgroundColor = borderColor.cgColor
        headerView.layer.addSublayer(bottomBorder)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60 - borderWidth
        }else {
            return cellHeight - borderWidth
        }
    }
}
