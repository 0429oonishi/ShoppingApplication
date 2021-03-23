import UIKit
import StoreKit

@available(iOS 13.0, *)
final class SettingViewController: UIViewController {

    private enum Url {
        case shareUrl
        case reportUrl
        var text: String {
            switch self {
            case .shareUrl: return "https://itunes.apple.com/jp/app/id1548230056?mt=8"
            case .reportUrl: return "https://docs.google.com/forms/d/1qFKDnISWjCZ8QyBpsGMaNX-wSQRw30NIJU5TQqUpsro/edit"
            }
        }
    }
    private enum SectionType {
        case general
        case support
        var text: String {
            switch self {
            case .general: return "一般"
            case .support: return "サポート"
            }
        }
    }
    private enum RowType {
        case change
        case introduce
        case evaluate
        case report
        var text: String {
            switch self {
            case .change: return "テーマカラー変更"
            case .introduce: return "このアプリを友達に紹介"
            case .evaluate: return "このアプリを評価"
            case .report: return "ご意見、ご要望、不具合の報告"
            }
        }
    }
    private let cellId = String(describing: SettingTableViewCell.self)
    private let sectionTypes: [SectionType] = [.general, .support]
    private let rowTypes: [[RowType]] = [[.change], [.introduce, .evaluate, .report]]
    private let borderWidth: CGFloat = 2
    private var cellHeight: CGFloat = 90

    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let cellNibName = String(describing: SettingTableViewCell.self)
            let cellNIB = UINib(nibName: cellNibName, bundle: nil)
            tableView.register(cellNIB, forCellReuseIdentifier: cellId)
            tableView.tableFooterView = UIView()
            tableView.isScrollEnabled = false
        }
    }
    @IBOutlet private weak var adMobView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        AdMob.addAdMobView(adMobView: adMobView,
                           width: self.view.frame.size.width,
                           height: adMobView.frame.size.height,
                           viewController: self)

        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.backgroundColor = UIColor.white.themeColor
        navigationBar.barTintColor = UIColor.white.themeColor
        tableView.reloadData()

    }

    private func transitionToThemeColorVC() {
        let storyboard = UIStoryboard(name: "ThemeColor", bundle: nil)
        guard let themeColorVC = storyboard.instantiateViewController(identifier: "themeColorVCId") as? ThemeColorViewController else { return }
        themeColorVC.modalPresentationStyle = .fullScreen
        present(themeColorVC, animated: true)
    }

    private func introduceAppToFriend() {
        let shareText = "おすすめのお買い物アプリです！\n買うものチェックリストや合計金額をお会計の前に計算できる計算機、お店を探せるマップが一つのアプリで完結します！\n「お買い物アプリ - MyCal(マイカル)」"
        guard let shareURL = URL(string: Url.shareUrl.text) else { return }
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
        guard let reportURL = URL(string: Url.reportUrl.text) else { return }
        if UIApplication.shared.canOpenURL(reportURL) {
            UIApplication.shared.open(reportURL as URL)
        }
    }

}

@available(iOS 13.0, *)
extension SettingViewController: UITableViewDelegate {

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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: cellHeight))
        let label = UILabel()
        let y = (section == 0) ? 20 - borderWidth : 50 - borderWidth
        label.frame = CGRect(x: 20, y: y, width: 100, height: 40)
        label.text = sectionTypes[section].text
        label.textColor = .black
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = borderWidth
        label.layer.borderColor = UIColor.black.themeColor.cgColor
        headerView.addSubview(label)
        let bottomBorder = CALayer()
        let bottomBorderX = label.frame.maxX + 20
        let bottomBorderY = label.frame.maxY - borderWidth
        let bottomBorderWidth = self.view.frame.size.width - bottomBorderX - 30
        bottomBorder.frame = CGRect(x: bottomBorderX,
                                    y: bottomBorderY,
                                    width: bottomBorderWidth,
                                    height: borderWidth)
        bottomBorder.backgroundColor = UIColor.black.themeColor.cgColor
        headerView.layer.addSublayer(bottomBorder)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? (60 - borderWidth) : (cellHeight - borderWidth)
    }

}

@available(iOS 13.0, *)
extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTypes[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SettingTableViewCell
        else {
            return UITableViewCell()
        }
        let text = rowTypes[indexPath.section][indexPath.row].text
        cell.configure(text: text)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTypes.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTypes[section].text
    }

}
