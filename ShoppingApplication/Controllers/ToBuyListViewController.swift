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
    @IBOutlet private weak var myTopView: UIView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var togglableAddViewButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var addView: UIView!
    @IBOutlet private weak var addTextField: UITextField!
    @IBOutlet private weak var addStepper: UIStepper!
    @IBOutlet private weak var addNumberLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var adMobView: UIView!

    private var isAddViewAppeared = true
    private var isKeyboardAppeared = false
    private var numberOfToBuy = 1
    private var toBuyLists: Results<RealmToBuyList>! { ToBuyListRealmRepository.shared.toDoLists }
    private var token: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        addTextField.delegate = self
        operateKeyboard()
        AdMob().load(to: adMobView, rootVC: self)
        token = toBuyLists.observe { [weak self] _ in
            guard let self = self else { return }
            self.remainCountButton.title = self.toBuyLists.isEmpty ? "" : "残り\(self.toBuyLists.count)個"
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addView.addBorder(width: 1, color: .black, position: .top)
        setupLayer()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupThemeColor()

    }

    @IBAction private func clearAllButtonDidTapped(_ sender: Any) {
        guard !toBuyLists.isEmpty else { return }
        showAlert()
    }

    @IBAction private func togglableAddViewButtonDidTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            let distance = self.view.frame.maxY - self.addView.frame.minY
            switch (self.isAddViewAppeared, self.isKeyboardAppeared) {
            case (true, true):
                self.addView.transform = CGAffineTransform(translationX: 0, y: distance)
                self.tableViewBottomConstraint.constant = 0
                self.tableViewBottomConstraint.constant -= self.addView.frame.size.height
                self.view.endEditing(true)
            case (false, false):
                self.addView.transform = .identity
                self.tableViewBottomConstraint.constant = 0
            case (false, true):
                fatalError("解せぬ挙動")
            case (true, false):
                self.addView.transform = CGAffineTransform(translationX: 0, y: distance)
                self.tableViewBottomConstraint.constant = 0
                self.tableViewBottomConstraint.constant -= self.addView.frame.size.height
            }
        }
    }

    @IBAction private func addStepperDidTapped(_ sender: UIStepper) {
        numberOfToBuy = Int(sender.value)
        addNumberLabel.text = "\(numberOfToBuy)"
    }

    @IBAction private func addButtonDidTapped(_ sender: Any) {
        guard let text = addTextField.text, !text.isEmpty else { return }
        let toBuyList = RealmToBuyList()
        toBuyList.title = text
        toBuyList.numberPurchased = numberOfToBuy
        toBuyList.isChecked = false
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
        let deleteAction = UIAlertAction(title: .delete, style: .destructive) { _ in
            let checkedToBuyLists = ToBuyListRealmRepository.shared.filter("isChecked == true")
            ToBuyListRealmRepository.shared.delete(checkedToBuyLists)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: .cancel, style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

}

// MARK: - setup
private extension ToBuyListViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(ToBuyListTableViewCell.nib,
                           forCellReuseIdentifier: ToBuyListTableViewCell.identifier)
    }

    func setupThemeColor() {
        myTopView.backgroundColor = UIColor.white.themeColor
        navigationBar.barTintColor = UIColor.white.themeColor
        addView.backgroundColor = UIColor.white.themeColor
        addButton.backgroundColor = UIColor.white.themeColor
        addTextField.layer.borderColor = UIColor.black.themeColor.cgColor
        if addButton.backgroundColor == .white {
            addButton.layer.borderColor = UIColor.black.cgColor
            addButton.layer.shadowColor = UIColor.black.cgColor
        } else {
            addButton.layer.borderColor = UIColor.white.cgColor
            addButton.layer.shadowColor = UIColor.white.cgColor
        }
    }

    func setupLayer() {
        addTextField.layer.masksToBounds = true
        addTextField.layer.borderWidth = 1
        addTextField.layer.cornerRadius = 10

        addStepper.layer.cornerRadius = 8
        addStepper.layer.borderColor = UIColor.white.cgColor
        addStepper.layer.borderWidth = 2

        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 10
        addButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addButton.layer.shadowRadius = 2
        addButton.layer.shadowOpacity = 1
    }

}

// MARK: - keyboard method
private extension ToBuyListViewController {

    func operateKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(viewDidTapped))
        tapGR.delegate = self
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }

    @objc
    func showKeyboard(notification: Notification) {
        guard let keyboardFrame = (
            notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        ).cgRectValue else { return }
        let distance = addView.frame.maxY - keyboardFrame.minY
        UIView.animate(withDuration: 0.15) {
            if self.isAddViewAppeared && !self.isKeyboardAppeared {
                self.addView.transform = CGAffineTransform(translationX: 0, y: -distance)
            }
        }
    }

    @objc
    func hideKeyboard() {
        UIView.animate(withDuration: 0.15) {
            self.addView.transform = .identity
        }
    }

    @objc
    func viewDidTapped() {
        UIView.animate(withDuration: 0.15) {
            switch (self.isAddViewAppeared, self.isKeyboardAppeared) {
            case (true, true):
                self.isAddViewAppeared = true
                self.isKeyboardAppeared = false
                self.tableViewBottomConstraint.constant = 0
                self.view.endEditing(true)

            case (false, false):
                self.isAddViewAppeared = true
                self.isKeyboardAppeared = false
                self.addView.transform = .identity
                self.tableViewBottomConstraint.constant = 0

            case (false, true):
                fatalError("解せぬ挙動")

            case (true, false):
                self.isAddViewAppeared = true
                self.isKeyboardAppeared = false
                self.tableViewBottomConstraint.constant = 0
                self.tableViewBottomConstraint.constant -= self.addView.frame.size.height
            }
        }
    }

}

// MARK: - UITableViewDelegate
extension ToBuyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}

// MARK: - UITableViewDataSource
extension ToBuyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toBuyLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ToBuyListTableViewCell.identifier,
            for: indexPath
        ) as! ToBuyListTableViewCell
        let toBuyList = toBuyLists[indexPath.row]
        cell.configure(toBuyList: toBuyList) {
            ToBuyListRealmRepository.shared.update {
                toBuyList.isChecked.toggle()
            }
            cell.checkButton(toBuyList: toBuyList)
        }
        return cell
    }

}

// MARK: - UITextFieldDelegate
extension ToBuyListViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }

}

// MARK: - UIGestureRecognizerDelegate
extension ToBuyListViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == addView {
            return false
        } else if touch.view == addButton {
            return false
        } else if touch.view == addStepper {
            return false
        } else if touch.view == togglableAddViewButton {
            return false
        } else {
            self.view.endEditing(true)
            return true
        }
    }

}
