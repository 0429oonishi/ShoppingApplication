//
//  ToBuyListViewController.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit
import RealmSwift

final class ToBuyListViewController: UIViewController {

    @IBOutlet private weak var remainCountButton: UIBarButtonItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addView: UIView! {
        didSet {
            addView.layer.borderWidth = 2
            addView.layer.borderColor = UIColor.white.cgColor
            addView.layer.shadowColor = UIColor.black.cgColor
            addView.layer.shadowOffset = CGSize(width: 5, height: -2)
            addView.layer.shadowRadius = 5
            addView.layer.shadowOpacity = 0.8
        }
    }
    @IBOutlet private weak var addTextField: UITextField! {
        didSet {
            addTextField.layer.masksToBounds = true
            addTextField.layer.borderWidth = 1
            addTextField.layer.cornerRadius = 10
        }
    }
    @IBOutlet private weak var addStepper: UIStepper! {
        didSet {
            addStepper.layer.cornerRadius = 8
            addStepper.layer.borderColor = UIColor.white.cgColor
            addStepper.layer.borderWidth = 2
            addStepper.backgroundColor = .white
        }
    }
    @IBOutlet private weak var addNumberLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton! {
        didSet {
            addButton.layer.borderWidth = 1
            addButton.layer.cornerRadius = 10
            addButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            addButton.layer.shadowRadius = 2
            addButton.layer.shadowOpacity = 1
        }
    }
    @IBOutlet private weak var adMobView: UIView!

    private var isKeyboardAppeared = false
    private var isAddViewAppeared = true
    private var numberOfToBuy = 1
    private var toDoLists: Results<ToBuyList>! { ToBuyListRealmRepository.shared.toDoLists }
    private var token: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToBuyListTableViewCell.nib,
                           forCellReuseIdentifier: ToBuyListTableViewCell.identifier)

        addTextField.delegate = self

        operateKeyboard()

        AdMob().load(to: adMobView, rootVC: self)

        token = toDoLists.observe { [unowned self] _ in
            remainCountButton.title = toDoLists.isEmpty ? "" : "残り\(toDoLists.count)個"
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupThemeColor()
        tableView.reloadData()

    }

    private func setupThemeColor() {
        self.view.backgroundColor = UIColor.white.themeColor
        navigationBar.barTintColor = UIColor.white.themeColor
        addView.backgroundColor = UIColor.white.themeColor
        addButton.backgroundColor = UIColor.white.themeColor
        addTextField.layer.borderColor = UIColor.black.themeColor.cgColor
        addButton.layer.borderColor = (addButton.backgroundColor == .white) ? UIColor.black.cgColor : UIColor.white.cgColor
        addButton.layer.shadowColor = (addButton.backgroundColor == .white) ? UIColor.black.cgColor : UIColor.white.cgColor
    }

    private func operateKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func showKeyboard(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        let toBuyViewMaxY = addView.frame.maxY
        let keyboardMinY = keyboardFrame.minY
        let distance = toBuyViewMaxY - keyboardMinY
        UIView.animate(withDuration: 0.2) {
            self.addView.transform = CGAffineTransform(translationX: 0, y: -distance)
        }
        isKeyboardAppeared.toggle()
    }

    @objc private func hideKeyboard() {
        UIView.animate(withDuration: 0.2) {
            self.addView.transform = .identity
        }
        isKeyboardAppeared.toggle()
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
        isKeyboardAppeared = true
    }

    @IBAction private func clearAllButtonDidTapped(_ sender: Any) {
        guard !toDoLists.isEmpty else { return }
        showAlert()
    }

    @IBAction private func toggleKeyboardButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            let distance = self.view.frame.maxY - addView.frame.minY
            addView.transform = isAddViewAppeared ? CGAffineTransform(translationX: 0, y: distance) : .identity
            isAddViewAppeared.toggle()
        }
    }

    @IBAction private func addStepperDidTapped(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
        addNumberLabel.text = "\(numberOfToBuy)"
    }

    @IBAction private func addButtonDidTapped(_ sender: Any) {
        guard let text = addTextField.text, !text.isEmpty else { return }
        let toBuyList = ToBuyList()
        toBuyList.toBuyListName = text
        toBuyList.toBuyListNumber = numberOfToBuy
        toBuyList.isButtonChecked = false
        ToBuyListRealmRepository.shared.add(toBuyList)

        tableView.reloadData()
        addTextField.text = ""
        addStepper.value = 1
        numberOfToBuy = 1
        addNumberLabel.text = "\(numberOfToBuy)"
    }

    private func showAlert() {
        let alert = UIAlertController(title: .deleteMemo,
                                      message: .deleteAttention,
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: .delete, style: .destructive) { [unowned self] _ in
            let checkedToBuyLists = ToBuyListRealmRepository.shared.filter("isButtonChecked == true")
            ToBuyListRealmRepository.shared.delete(checkedToBuyLists)
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: .cancel, style: .cancel) { [unowned self] _ in
            dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
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
        return toDoLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToBuyListTableViewCell.identifier,
                                                       for: indexPath) as? ToBuyListTableViewCell
        else { return UITableViewCell() }
        let toDoList = toDoLists[indexPath.row]
        cell.configure(toDoList: toDoList)
        cell.index = indexPath.row
        return cell
    }

}

extension ToBuyListViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }

}
