
import UIKit
import RealmSwift
import GoogleMobileAds

final class ToBuyListViewController: UIViewController {
    
    private let toBuyListCellId = String(describing: ToBuyListTableViewCell.self)
    private let toBuyListCellNibName = "ToBuyListTableViewCell"
    private let AdMobId = "ca-app-pub-5791981660348332/8471327283"
    private var isKeyboardAppeared = true
    private var numberOfToBuy = 1
    private var realm = try! Realm()
    private var objects: Results<ToBuyList>!
    private var token: NotificationToken!
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
    
    @IBOutlet weak private var remainCountButton: UIBarButtonItem!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            let cellNIB = UINib(nibName: toBuyListCellNibName, bundle: nil)
            tableView.register(cellNIB, forCellReuseIdentifier: toBuyListCellId)
        }
    }
    @IBOutlet weak private var addView: UIView! {
        didSet {
            addView.layer.borderWidth = 2
            addView.layer.borderColor = UIColor.white.cgColor
            addView.layer.shadowColor = UIColor.black.cgColor
            addView.layer.shadowOffset = CGSize(width: 5, height: -2)
            addView.layer.shadowRadius = 5
            addView.layer.shadowOpacity = 0.8
        }
    }
    @IBOutlet weak private var addTextField: UITextField! {
        didSet {
            addTextField.layer.masksToBounds = true
            addTextField.layer.borderWidth = 1
            addTextField.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak private var addStepper: UIStepper! {
        didSet {
            addStepper.layer.cornerRadius = 8
            addStepper.layer.borderColor = UIColor.white.cgColor
            addStepper.layer.borderWidth = 2
            addStepper.backgroundColor = .white
        }
    }
    @IBOutlet weak private var addNumberLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton! {
        didSet {
            addButton.layer.borderWidth = 1
            addButton.layer.cornerRadius = 10
            addButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            addButton.layer.shadowRadius = 2
            addButton.layer.shadowOpacity = 1
        }
    }
    @IBOutlet weak private var adMobView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        addTextField.delegate = self

        objects = realm.objects(ToBuyList.self)
        operateKeyboard()
        addAdMobView()
        
        token = objects.observe { [self] (notification) in
            remainCountButton.title = ""
            if objects.count != 0 {
                remainCountButton.title = "残り\(objects.count)個"
            } else {
                remainCountButton.title = ""
            }
        }
    }
    
    private func addAdMobView() {
        var AdMobView = GADBannerView()
        AdMobView = GADBannerView(adSize: kGADAdSizeBanner)
        AdMobView.frame.size = CGSize(width: self.view.frame.size.width, height: adMobView.frame.size.height)
        AdMobView.adUnitID = AdMobId
        AdMobView.rootViewController = self
        AdMobView.load(GADRequest())
        adMobView.addSubview(AdMobView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = themeColor
        navigationBar.barTintColor = themeColor
        addView.backgroundColor = themeColor
        addButton.backgroundColor = themeColor
        addTextField.layer.borderColor = borderColor.cgColor
        if addButton.backgroundColor == .white {
            addButton.layer.borderColor = UIColor.black.cgColor
            addButton.layer.shadowColor = UIColor.black.cgColor
        }  else {
            addButton.layer.borderColor = UIColor.white.cgColor
            addButton.layer.shadowColor = UIColor.white.cgColor
        }
        tableView.reloadData()
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
        let toBuyViewMaxY = addView.frame.maxY
        let keyboardMinY = keyboardFrame.minY
        let distance = toBuyViewMaxY - keyboardMinY
        if isKeyboardAppeared {
            UIView.animate(withDuration: 0.1) {
                self.addView.transform = CGAffineTransform(translationX: 0, y: -distance)
            }
            isKeyboardAppeared = !isKeyboardAppeared
        }
    }
    
    @objc func hideKeyboard() {
        if !isKeyboardAppeared {
            UIView.animate(withDuration: 0.1) {
                self.addView.transform = .identity
            }
            isKeyboardAppeared = !isKeyboardAppeared
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func clearAllButtonDidTapped(_ sender: Any) {
        if objects.count != 0 {
            let alert = UIAlertController(title: "チェックしたメモを\n消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
            let alertDefaultAction = UIAlertAction(title: "メモを消去する", style: .default) { [self] (_) in
                try! realm.write {
                    //toBuyListCheckFlagは変わらないことに注意
                    let checkObjects = realm.objects(ToBuyList.self).filter("toBuyListCheckFlag == true")
                    realm.delete(checkObjects)
                }
                tableView.reloadData()
            }
            let alertCancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(alertDefaultAction)
            alert.addAction(alertCancelAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func toggleKeyboardButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) { [self] in
            if isKeyboardAppeared {
                let distance = view.frame.maxY - addView.frame.minY
                addView.transform = CGAffineTransform(translationX: 0, y: distance)
            } else {
                addView.transform = .identity
            }
        }
    }
    
    @IBAction func addStepperDidTapped(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
        addNumberLabel.text = String(numberOfToBuy)
    }
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        if addTextField.text != "" {
            guard let text = addTextField.text else { return }
            let toBuyList = ToBuyList()
            toBuyList.toBuyListName = text
            toBuyList.toBuyListNumber = numberOfToBuy
            toBuyList.toBuyListCheckFlag = false
            try! realm.write {
                realm.add(toBuyList)
            }
            tableView.reloadData()
        }
        addTextField.text = ""
        addNumberLabel.text = "1"
        addStepper.value = 1
        numberOfToBuy = 1
    }
}

extension ToBuyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ToBuyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: toBuyListCellId, for: indexPath) as? ToBuyListTableViewCell
        else {
            return UITableViewCell()
        }
        cell.indexPathRow = indexPath.row
        let object = objects[indexPath.row]
        cell.setCell(object: object)
        return cell
    }
    
}

extension ToBuyListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}
