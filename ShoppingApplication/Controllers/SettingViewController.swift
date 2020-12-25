


import UIKit

/*
 テーマカラー
 このアプリを友達に紹介する
 このアプリを評価する
 ご意見、ご要望、不具合の報告はこちら
 
 */

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    private let settingCellId = "settingCellId"
    private let settingArray = ["テーマカラー変更", "このアプリを友達に紹介", "このアプリを評価", "ご意見、ご要望、不具合の報告"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: settingCellId)
    }


}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath) as! SettingTableViewCell
        cell.settingTitleLabel.text = settingArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingTableView.frame.size.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }

    
}

