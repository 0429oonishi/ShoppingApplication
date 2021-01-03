
import UIKit
import RealmSwift
import GoogleMobileAds

class ToBuyListViewController: UIViewController {
    
    private let toBuyListCellId = "toBuyListCellId"
    private var toggleKeyboardFlag = true
    private var numberOfToBuy = 1
    private var realm = try! Realm()
    var objects: Results<ToBuyList>!
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
    
    @IBOutlet weak var toBuyRemainCountLabel: UILabel!
    @IBOutlet weak var toBuyListNavigationBar: UINavigationBar!
    @IBOutlet weak var toBuyListTableView: UITableView! {
        didSet {
            toBuyListTableView.delegate = self
            toBuyListTableView.dataSource = self
            toBuyListTableView.register(UINib(nibName: "ToBuyListTableViewCell", bundle: nil), forCellReuseIdentifier: toBuyListCellId)
        }
    }
    @IBOutlet weak var toBuyListToAddView: UIView! {
        didSet {
            toBuyListToAddView.layer.borderWidth = 2
            toBuyListToAddView.layer.borderColor = UIColor.white.cgColor
            toBuyListToAddView.layer.shadowColor = UIColor.black.cgColor
            toBuyListToAddView.layer.shadowOffset = CGSize(width: 5, height: -2)
            toBuyListToAddView.layer.shadowRadius = 5
            toBuyListToAddView.layer.shadowOpacity = 0.8
        }
    }
    @IBOutlet weak var toBuyListToAddTextField: UITextField! {
        didSet {
            toBuyListToAddTextField.delegate = self
            toBuyListToAddTextField.layer.masksToBounds = true
            toBuyListToAddTextField.layer.borderWidth = 1
            toBuyListToAddTextField.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var toBuyListToAddStepper: UIStepper! {
        didSet { toBuyListToAddStepper.layer.cornerRadius = 8 }
    }
    @IBOutlet weak var toBuyListToAddNumberLabel: UILabel!
    @IBOutlet weak var toBuyListToAddButton: UIButton! {
        didSet {
            toBuyListToAddButton.layer.borderWidth = 1
            toBuyListToAddButton.layer.cornerRadius = 10
            toBuyListToAddButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            toBuyListToAddButton.layer.shadowRadius = 2
            toBuyListToAddButton.layer.shadowOpacity = 1
        }
    }
    @IBOutlet weak var adMobView: UIView!
    private let adMobId = "ca-app-pub-5791981660348332/8471327283"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(ToBuyList.self)
        remainCount()
        operateKeyboard()
        addAdMobView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = themeColor
        toBuyListNavigationBar.barTintColor = themeColor
        toBuyListToAddView.backgroundColor = themeColor
        toBuyListToAddButton.backgroundColor = themeColor
        toBuyListToAddTextField.layer.borderColor = borderColor.cgColor
        if toBuyListToAddButton.backgroundColor == .white {
            toBuyListToAddButton.layer.borderColor = UIColor.black.cgColor
            toBuyListToAddButton.layer.shadowColor = UIColor.black.cgColor
        }else {
            toBuyListToAddButton.layer.borderColor = UIColor.white.cgColor
            toBuyListToAddButton.layer.shadowColor = UIColor.white.cgColor
        }
        toBuyListTableView.reloadData()
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
    
    private func operateKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func showKeyboard(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        let toBuyViewMaxY = toBuyListToAddView.frame.maxY
        let keyboardMinY = keyboardFrame.minY
        let distance = toBuyViewMaxY - keyboardMinY
        if toggleKeyboardFlag {
            UIView.animate(withDuration: 0.1) {
                self.toBuyListToAddView.transform = CGAffineTransform(translationX: 0, y: -distance)
            }
            toggleKeyboardFlag = false
        }
    }
    
    @objc func hideKeyboard() {
        if !toggleKeyboardFlag {
            UIView.animate(withDuration: 0.1) {
                self.toBuyListToAddView.transform = .identity
            }
            toggleKeyboardFlag = true
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func toBuyListClearAll(_ sender: Any) {
        if objects.count != 0 {
            let alert = UIAlertController(title: "チェックしたメモを\n消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
            let alertDefaultAction = UIAlertAction(title: "メモを消去する", style: .default) { (_) in
                try! self.realm.write {
                    let checkObjects = self.realm.objects(ToBuyList.self).filter("toBuyListCheckFlag == true")
                    self.realm.delete(checkObjects)
                }
                self.remainCount()
                self.toBuyListTableView.reloadData()
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
        UIView.animate(withDuration: 0.1) {
            if self.toggleKeyboardFlag {
                let distance = self.view.frame.maxY - self.toBuyListToAddView.frame.minY
                self.toBuyListToAddView.transform = CGAffineTransform(translationX: 0, y: distance)
            }else {
                self.toBuyListToAddView.transform = .identity
            }
        }
    }
    
    @IBAction func tappedToBuyListToAddStepper(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
        toBuyListToAddNumberLabel.text = String(numberOfToBuy)
    }
    
    @IBAction func tappedToBuyListToAddButton(_ sender: Any) {
        if toBuyListToAddTextField.text != "" {
            if let text = toBuyListToAddTextField.text {
                let toBuyList = ToBuyList()
                toBuyList.toBuyListName = text
                toBuyList.toBuyListNumber = numberOfToBuy
                toBuyList.toBuyListCheckFlag = false
                try! realm.write {
                    realm.add(toBuyList)
                }
                toBuyListTableView.reloadData()
            }
        }
        
        remainCount()
        toBuyListToAddTextField.text = ""
        toBuyListToAddNumberLabel.text = "1"
        toBuyListToAddStepper.value = 1
        numberOfToBuy = 1
    }
    
    private func remainCount() {
        if objects.count != 0 {
            toBuyRemainCountLabel.text = "残り\(objects.count)個"
        }else {
            toBuyRemainCountLabel.text = ""
        }
    }
}

extension ToBuyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toBuyListTableView.dequeueReusableCell(withIdentifier: toBuyListCellId, for: indexPath) as! ToBuyListTableViewCell
        cell.indexPathRow = indexPath.row
        cell.setCell(object: objects[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return toBuyListTableView.frame.height / 10
    }
}

extension ToBuyListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
