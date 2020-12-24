
import UIKit

class MemoViewController: UIViewController {
    
    @IBOutlet weak var toBuyRemainCountLabel: UILabel!
    @IBOutlet weak var toBuyListTableView: UITableView!
    @IBOutlet weak var toBuyView: UIView!
    @IBOutlet weak var toBuyTextField: UITextField!
    @IBOutlet weak var toBuyStepper: UIStepper!
    @IBOutlet weak var toBuyNumberLabel: UILabel!
    private var toggleKeyboardFlag = true
    private let cellId = "toBuyListCellId"
    private var toBuyListArray: [String] = [] {
        didSet {
            toBuyListTableView.reloadData()
            if toBuyListArray.count != 0 {
                toBuyRemainCountLabel.text = "残り\(toBuyListArray.count)個"
            }else {
                toBuyRemainCountLabel.text = ""
            }
        }
    }
    private var numberOfToBuy = 1
    private var numberOfToBuyArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toBuyTextField.delegate = self
        
        toBuyListTableView.delegate = self
        toBuyListTableView.dataSource = self
        toBuyListTableView.register(UINib(nibName: "ToBuyListTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func showKeyboard(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        let toBuyViewMaxY = toBuyView.frame.maxY
        let keyboardMinY = keyboardFrame.minY
        let distance = toBuyViewMaxY - keyboardMinY
        if toggleKeyboardFlag {
            UIView.animate(withDuration: 0.1) {
                self.toBuyView.transform = CGAffineTransform(translationX: 0, y: -distance)
            }
            toggleKeyboardFlag = false
        }
        
    }
    
    @objc func hideKeyboard() {
        if !toggleKeyboardFlag {
            UIView.animate(withDuration: 0.1) {
                self.toBuyView.transform = .identity
            }
            toggleKeyboardFlag = true
        }
    }
    
    @IBAction func toBuyListClearAll(_ sender: Any) {
        if numberOfToBuyArray.count != 0 {
            let alert = UIAlertController(title: "チェックしたメモを\n消去しますか？", message: "消去したものは元に戻せません。", preferredStyle: .alert)
            let alertDefaultAction = UIAlertAction(title: "メモを消去する", style: .default) { (_) in
                //checkmarkついてるものだけ消去
                self.toBuyListArray.removeAll()
                self.numberOfToBuyArray.removeAll()
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
        if toggleKeyboardFlag {
            UIView.animate(withDuration: 0.1) {
                let distance = self.view.frame.maxY - self.toBuyView.frame.minY
                self.toBuyView.transform = CGAffineTransform(translationX: 0, y: distance)
                self.toBuyView.transform = CGAffineTransform(translationX: 0, y: distance)
            }
        }else {
            UIView.animate(withDuration: 0.1) {
                self.toBuyView.transform = .identity
                self.toBuyView.transform = .identity
            }
        }
     
    }
    
    @IBAction func tappedToBuyStepper(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
        toBuyNumberLabel.text = String(numberOfToBuy)
    }
    
    @IBAction func tappedCloseKeyboardButton(_ sender: Any) {
        
    }
    
    //追加buttonを押したときはviewを閉じないようにする
    @IBAction func tappedToBuyAddButton(_ sender: Any) {
        if toBuyTextField.text != "" {
            if let text = toBuyTextField.text {
                toBuyListArray.append(text)
                numberOfToBuyArray.append(numberOfToBuy)
            }
        }
        
        toBuyTextField.text = ""
        toBuyNumberLabel.text = "1"
        toBuyStepper.value = 1
        numberOfToBuy = 1
    }
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toBuyListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toBuyListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ToBuyListTableViewCell
        cell.toBuyTitleLabel.text = toBuyListArray[indexPath.row]
        cell.numberOfToBuyLabel.text = "×\(numberOfToBuyArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return toBuyListTableView.frame.height / 10
    }
    
}

extension MemoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}
