//
//  ChildTableViewCell.swift
//  AlefTest
//
//  Created by  Егор Шуляк on 23.02.22.
//

import UIKit

class ChildTableViewCell: UITableViewCell {
    
    
    static let nib = UINib(nibName: String(describing: ChildTableViewCell.self), bundle: nil)
    static let reuseID = String(describing: ChildTableViewCell.self)
    let lightGray = UIColor.lightGray.withAlphaComponent(0.2)
    
    private lazy var regexForAge = "^[0-9]*$"
    private lazy var regexForName = "^[а-яА-Яa-zA-Z\\s]*$"
    
    var delegate: DeleteCellDelegate?
    
    @IBOutlet var childNameField: UITextField!
    @IBOutlet var childAgeField: UITextField!
    @IBOutlet var viewName: UIView!
    @IBOutlet var viewAge: UIView!
    @IBOutlet var cellSize: NSLayoutConstraint!
    
    @IBAction func deleteCell (sender: UIButton) {
        delegate?.deleteCell(cell: self)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if let superView = superview {
            cellSize.constant = superView.frame.size.width / 2
        }
    }
    
    private func configureViews() {
        viewName.layer.cornerRadius = 5
        viewName.layer.borderWidth = 1
        viewName.layer.borderColor = lightGray.cgColor
        
        viewAge.layer.cornerRadius = 5
        viewAge.layer.borderWidth = 1
        viewAge.layer.borderColor = lightGray.cgColor
    }
    
    private func checkValidation(text: String, field: UITextField) {
        guard let borderView = field.superview else { return }
        let regex = (field === childNameField) ? regexForName : regexForAge
        
        if text.regexMatches(regex) {
            borderView.layer.borderColor = lightGray.cgColor
        } else {
            borderView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}

extension ChildTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === childNameField {
            childAgeField.becomeFirstResponder()
        } else {
            childAgeField.resignFirstResponder()
            delegate?.saveCell(cell: self)
        }
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
}
