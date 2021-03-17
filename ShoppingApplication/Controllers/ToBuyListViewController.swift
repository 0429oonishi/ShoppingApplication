
import UIKit
import RealmSwift

//themeColorを共通化
//adMobViewをViewに切り分け
//realmの処理を切り分ける

final class ToBuyListViewController: UIViewController {
    
    private let toBuyListCellId = String(describing: ToBuyListTableViewCell.self)
    private var isKeyboardAppeared = false
    private var isAddViewAppeared = true
    private var numberOfToBuy = 1 {
        didSet {
            addNumberLabel.text = "\(numberOfToBuy)"
        }
    }
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
            let cellNibName = String(describing: ToBuyListTableViewCell.self)
            let cellNib = UINib(nibName: cellNibName, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: toBuyListCellId)
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
    @IBOutlet weak private var addButton: UIButton! {
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
        
        operateKeyboard()
        
        AdMob.addAdMobView(adMobView: adMobView,
                           width: self.view.frame.size.width,
                           height: adMobView.frame.size.height,
                           viewController: self)
        
        objects = realm.objects(ToBuyList.self)
        token = objects.observe { [self] (notification) in
            remainCountButton.title = (objects.count != 0) ? "残り\(objects.count)個" : ""
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = themeColor
        navigationBar.barTintColor = themeColor
        addView.backgroundColor = themeColor
        addButton.backgroundColor = themeColor
        addTextField.layer.borderColor = borderColor.cgColor
        addButton.layer.borderColor = (addButton.backgroundColor == .white) ? UIColor.black.cgColor : UIColor.white.cgColor
        addButton.layer.shadowColor = (addButton.backgroundColor == .white) ? UIColor.black.cgColor : UIColor.white.cgColor
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
        UIView.animate(withDuration: 0.2) {
            self.addView.transform = CGAffineTransform(translationX: 0, y: -distance)
        }
        isKeyboardAppeared = !isKeyboardAppeared
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.2) {
            self.addView.transform = .identity
        }
        isKeyboardAppeared = !isKeyboardAppeared
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        isKeyboardAppeared = true
    }
    
    @IBAction func clearAllButtonDidTapped(_ sender: Any) {
        if objects.count != 0 {
            showAlert()
        }
    }
    
    @IBAction func toggleKeyboardButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [self] in
            let distance = self.view.frame.maxY - addView.frame.minY
            addView.transform = isAddViewAppeared ? CGAffineTransform(translationX: 0, y: distance) : .identity
            isAddViewAppeared = !isAddViewAppeared
        }
    }
    
    @IBAction func addStepperDidTapped(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
    }
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        guard let text = addTextField.text else { return }
        if text != "" {
            let toBuyList = ToBuyList()
            toBuyList.toBuyListName = text
            toBuyList.toBuyListNumber = numberOfToBuy
            toBuyList.isButtonChecked = false
            try! realm.write {
                realm.add(toBuyList)
            }
            tableView.reloadData()
            addTextField.text = ""
            addStepper.value = 1
            numberOfToBuy = 1
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "チェックしたメモを\n消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "メモを消去する", style: .destructive) { [self] (_) in
            try! realm.write {
                let checkObjects = realm.objects(ToBuyList.self).filter("isButtonChecked == true")
                realm.delete(checkObjects)
            }
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { [self] (_) in
            dismiss(animated: true, completion: nil)
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
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
        let object = objects[indexPath.row]
        cell.setupCell(object: object)
        cell.index = indexPath.row
        return cell
    }
    
}

extension ToBuyListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}
