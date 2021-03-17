
import UIKit
import RealmSwift
import GoogleMobileAds

final class ToBuyListViewController: UIViewController {
    
    private let CELL_ID = String(describing: ToBuyListTableViewCell.self)
    private let CELL_NIB_NAME = "ToBuyListTableViewCell"
    private let AD_MOB_ID = "ca-app-pub-5791981660348332/8471327283"
    private var toggleKeyboardFlag = true
    private var numberOfToBuy = 1
    private var realm = try! Realm()
    private var objects: Results<ToBuyList>!
    private var toBuyListToken: NotificationToken!
    private var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .white
        }
        return UIColor(code: themeColorString)
    }
    private var borderColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .black
        }
        return UIColor(code: themeColorString)
    }
    
    @IBOutlet weak var toBuyListRemainCountButton: UIBarButtonItem!
    @IBOutlet weak var toBuyListNavigationBar: UINavigationBar!
    @IBOutlet weak var toBuyListTableView: UITableView! {
        didSet {
            toBuyListTableView.delegate = self
            toBuyListTableView.dataSource = self
            let cellNIB = UINib(nibName: CELL_NIB_NAME, bundle: nil)
            toBuyListTableView.register(cellNIB, forCellReuseIdentifier: CELL_ID)
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
        didSet {
            toBuyListToAddStepper.layer.cornerRadius = 8
            toBuyListToAddStepper.layer.borderColor = UIColor.white.cgColor
            toBuyListToAddStepper.layer.borderWidth = 2
            toBuyListToAddStepper.backgroundColor = .white
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(ToBuyList.self)
        operateKeyboard()
        addAdMobView()
        
        toBuyListToken = objects.observe { [self] (notification) in
            toBuyListRemainCountButton.title = ""
            if objects.count != 0 {
                toBuyListRemainCountButton.title = "残り\(objects.count)個"
            }else {
                toBuyListRemainCountButton.title = ""
            }
        }
    }
    
    private func addAdMobView() {
        var AdMobView = GADBannerView()
        AdMobView = GADBannerView(adSize: kGADAdSizeBanner)
        AdMobView.frame.size = CGSize(width: self.view.frame.size.width, height: adMobView.frame.size.height)
        AdMobView.adUnitID = AD_MOB_ID
        AdMobView.rootViewController = self
        AdMobView.load(GADRequest())
        adMobView.addSubview(AdMobView)
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
            toggleKeyboardFlag = !toggleKeyboardFlag
        }
    }
    
    @objc func hideKeyboard() {
        if !toggleKeyboardFlag {
            UIView.animate(withDuration: 0.1) {
                self.toBuyListToAddView.transform = .identity
            }
            toggleKeyboardFlag = !toggleKeyboardFlag
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func toBuyListClearAll(_ sender: Any) {
        if objects.count != 0 {
            let alert = UIAlertController(title: "チェックしたメモを\n消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
            let alertDefaultAction = UIAlertAction(title: "メモを消去する", style: .default) { [self] (_) in
                try! realm.write {
                    let checkObjects = realm.objects(ToBuyList.self).filter("toBuyListCheckFlag == true")
                    realm.delete(checkObjects)
                }
                toBuyListTableView.reloadData()
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
        UIView.animate(withDuration: 0.1) { [self] in
            if toggleKeyboardFlag {
                let distance = view.frame.maxY - toBuyListToAddView.frame.minY
                toBuyListToAddView.transform = CGAffineTransform(translationX: 0, y: distance)
            }else {
                toBuyListToAddView.transform = .identity
            }
        }
    }
    
    @IBAction func tappedToBuyListToAddStepper(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
        toBuyListToAddNumberLabel.text = String(numberOfToBuy)
    }
    
    @IBAction func tappedToBuyListToAddButton(_ sender: Any) {
        if toBuyListToAddTextField.text != "" {
            guard let text = toBuyListToAddTextField.text else { return }
            let toBuyList = ToBuyList()
            toBuyList.toBuyListName = text
            toBuyList.toBuyListNumber = numberOfToBuy
            toBuyList.toBuyListCheckFlag = false
            try! realm.write {
                realm.add(toBuyList)
            }
            toBuyListTableView.reloadData()
        }
        toBuyListToAddTextField.text = ""
        toBuyListToAddNumberLabel.text = "1"
        toBuyListToAddStepper.value = 1
        numberOfToBuy = 1
    }
}

extension ToBuyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = toBuyListTableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? ToBuyListTableViewCell
        else {
            return UITableViewCell()
        }
        cell.indexPathRow = indexPath.row
        let object = objects[indexPath.row]
        cell.setCell(object: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ToBuyListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}
