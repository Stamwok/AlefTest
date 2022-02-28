//
//  ViewController.swift
//  AlefTest
//
//  Created by  Егор Шуляк on 22.02.22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DeleteCellDelegate {
    
    //MARK: - initiate
    @IBOutlet var tableView: UITableView!
    @IBOutlet var parentNameField: UITextField!
    @IBOutlet var parentAgeField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var viewName: UIView!
    @IBOutlet var viewAge: UIView!
    var clearButton: UIButton!

    private let lightGray = UIColor.lightGray.withAlphaComponent(0.2)
    private let lightBlue = UIColor.systemBlue.withAlphaComponent(0.6)
    
    private lazy var regexForAge = "^[0-9]*$"
    private lazy var regexForName = "^[а-яА-Яa-zA-Z\\s]*$"
    
    
    var childrenContainer: [(String, String)] = [] {
        didSet {
            changeClearButtonState()
            
            if childrenContainer.count < 1 {
                tableView.isScrollEnabled = false
            } else {
                tableView.isScrollEnabled = true
            }
            
            if childrenContainer.count >= 5 {
                addButton.isHidden = true
            } else {
                addButton.isHidden = false
            }
            
            UIView.animate(withDuration: 0.2) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        tableView.register(ChildTableViewCell.nib, forCellReuseIdentifier: ChildTableViewCell.reuseID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       configureFooterView()
    }
    
    private func configureViews() {
        addButton.layer.cornerRadius = 25
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = lightBlue.cgColor
        addButton.setTitleColor(lightBlue, for: .normal)
        
        viewName.layer.cornerRadius = 5
        viewName.layer.borderWidth = 1
        viewName.layer.borderColor = lightGray.cgColor
        
        viewAge.layer.cornerRadius = 5
        viewAge.layer.borderWidth = 1
        viewAge.layer.borderColor = lightGray.cgColor
    }
    
    private func configureFooterView () {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        clearButton = UIButton(frame: addButton.frame)
        clearButton.layer.cornerRadius = 25
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.setTitleColor(UIColor.systemRed, for: .normal)
        clearButton.titleLabel?.font = addButton.titleLabel?.font
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.systemRed.cgColor
        clearButton.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        clearButton.isHidden = true
        footerView.addSubview(clearButton)
        
        clearButton.center = footerView.center
        tableView.tableFooterView = footerView
        tableView.isScrollEnabled = false
    }
    
    //MARK: - actions
    
    @IBAction func addChild() {
        childrenContainer.append(("", ""))
    }
    
    private func changeClearButtonState() {
        guard let textName = parentNameField.text, let textAge = parentAgeField.text else { return }
        if (textName + textAge).isEmpty && childrenContainer.count < 1 {
            clearButton.isHidden = true
        } else {
            clearButton.isHidden = false
        }
    }
    
    @objc private func clearData(sender: UIButton) {
        configureAlertView()
        changeClearButtonState()
    }
    
    private func configureAlertView() {
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "Сбросить", style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            self.parentNameField.text = ""
            self.parentAgeField.text = ""
            self.childrenContainer = []
            self.configureViews()
        }))
        alertView.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    private func checkValidation(text: String, field: UITextField) {
        guard let borderView = field.superview else { return }
        let regex = (field === parentNameField) ? regexForName : regexForAge
        
        if text.regexMatches(regex) {
            borderView.layer.borderColor = lightGray.cgColor
        } else {
            borderView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenContainer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildTableViewCell.reuseID, for: indexPath) as? ChildTableViewCell else { fatalError("wrong cell") }
        cell.delegate = self
        let dataForCell = childrenContainer[indexPath.row]
        cell.childNameField.text = dataForCell.0
        cell.childAgeField.text = dataForCell.1
        return cell
    }

    //MARK: - textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === parentNameField {
            parentAgeField.becomeFirstResponder()
        } else {
            parentAgeField.resignFirstResponder()
        }
        changeClearButtonState()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") + string
        let res: String
        
        if range.length >= 1 && string == "" {
            let end = text.index(text.startIndex, offsetBy: text.count - range.length)
            res = String(text[text.startIndex..<end])
        } else {
            res = text
        }
        
        checkValidation(text: res, field: textField)
        textField.text = res
        return false
    }
    
    //MARK: - DeleteCellDelegate
    func deleteCell(cell: UITableViewCell) {
        guard let cellNum = tableView.indexPath(for: cell) else { return }
        childrenContainer.remove(at: cellNum.row)
    }
    
    func saveCell(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let cell = cell as? ChildTableViewCell else { return }
        let dataFromCell = (cell.childNameField.text ?? "", cell.childAgeField.text ?? "")
        childrenContainer[indexPath.row] = dataFromCell
    }
}
