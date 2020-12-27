
import UIKit
import RealmSwift

//.redのところは後でテーマカラーで変更できるようにする

class ToBuyListViewController: UIViewController {
    
    @IBOutlet weak var toBuyRemainCountLabel: UILabel!
    @IBOutlet weak var toBuyListNavigationBar: UINavigationBar! {
        didSet { toBuyListNavigationBar.barTintColor = .red }
    }
    @IBOutlet weak var toBuyListTableView: UITableView! {
        didSet {
            toBuyListTableView.delegate = self
            toBuyListTableView.dataSource = self
            toBuyListTableView.register(UINib(nibName: "ToBuyListTableViewCell", bundle: nil), forCellReuseIdentifier: toBuyListCellId)
        }
    }
    @IBOutlet weak var toBuyListToAddView: UIView! {
        didSet {
            toBuyListToAddView.backgroundColor = .red
            toBuyListToAddView.layer.borderWidth = 2
            toBuyListToAddView.layer.borderColor = UIColor.white.cgColor
            toBuyListToAddView.layer.shadowColor = UIColor.black.cgColor
            toBuyListToAddView.layer.shadowOffset = CGSize(width: 5, height: -2)
            toBuyListToAddView.layer.shadowRadius = 5
            toBuyListToAddView.layer.shadowOpacity = 0.8
        }
    }
    @IBOutlet weak var toBuyListToAddTextField: UITextField! {
        didSet { toBuyListToAddTextField.delegate = self }
    }
    @IBOutlet weak var toBuyListToAddStepper: UIStepper! {
        didSet { toBuyListToAddStepper.layer.cornerRadius = 8 }
    }
    @IBOutlet weak var toBuyListToAddNumberLabel: UILabel!
    @IBOutlet weak var closeKeyboardButton: UIButton! {
        didSet {
            closeKeyboardButton.backgroundColor = .red
            closeKeyboardButton.layer.borderWidth = 2
            closeKeyboardButton.layer.borderColor = UIColor.white.cgColor
            closeKeyboardButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var toBuyListToAddButton: UIButton! {
        didSet {
            toBuyListToAddButton.backgroundColor = .red
            toBuyListToAddButton.layer.borderWidth = 2
            toBuyListToAddButton.layer.borderColor = UIColor.white.cgColor
            toBuyListToAddButton.layer.cornerRadius = 10
        }
    }

    private let toBuyListCellId = "toBuyListCellId"
    private var toggleKeyboardFlag = true
    private var numberOfToBuy = 1
    private var realm = try! Realm()
    private var toBuyList = ToBuyList()
    var objects: Results<ToBuyList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(ToBuyList.self)
        
        remainCount()
        self.view.backgroundColor = .red
        operateKeyboard()
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
    
    //全て消去した後のバグを修正する
    @IBAction func toBuyListClearAll(_ sender: Any) {
        if objects.count != 0 {
            let alert = UIAlertController(title: "チェックしたメモを\n消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
            let alertDefaultAction = UIAlertAction(title: "メモを消去する", style: .default) { (_) in
                //checkmarkついてるものだけ消去
                do {
                    try self.realm.write {
                        self.objects = self.realm.objects(ToBuyList.self)
                        self.realm.delete(self.objects)
                    }
                }catch {
                    print("error at toBuyListClearAll")
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
    
    @IBAction func tappedCloseKeyboardButton(_ sender: Any) {
        
    }
    
    //追加buttonを押したときはviewを閉じないようにする
    @IBAction func tappedToBuyListToAddButton(_ sender: Any) {
        if toBuyListToAddTextField.text != "" {
            if let text = toBuyListToAddTextField.text {
                toBuyList = ToBuyList()
                toBuyList.toBuyListName = text
                toBuyList.toBuyLisNumber = numberOfToBuy
                do {
                    try realm.write {
                        realm.add(toBuyList)
                    }
                }catch {
                    print("DEBUG_PRINT: errror at tappedToBuyListToAddButton")
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

        cell.toBuyListCellTitleLabel.text = objects[indexPath.row].toBuyListName
        cell.numberOfToBuyLabel.text = "×\(objects[indexPath.row].toBuyLisNumber)"
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return toBuyListTableView.frame.height / 10
    }
    
}

extension ToBuyListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}
