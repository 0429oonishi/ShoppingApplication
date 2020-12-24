


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
    private let settingArray = ["テーマカラー", "このアプリを友達に紹介する", "このアプリを評価する", "ご意見、ご要望、不具合の報告はこちら"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self

    }


}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = settingArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingTableView.frame.size.height / 10
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
//    }
//
    
}

