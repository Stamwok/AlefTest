//
//  ChildCell.swift
//  AlefTest
//
//  Created by  Егор Шуляк on 22.02.22.
//

import UIKit

class ChildCell: UITableViewCell {
    
    
    
    static let nib = UINib(nibName: String(describing: ChildCell.self), bundle: nil)
    static let reuseID = String(describing: ChildCell.self)
    let lightGray = UIColor.lightGray.withAlphaComponent(0.2)
    var delegate: DeleteCellDelegate?
    var cellID = 0
    
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
        // Initialization code
        configureViews()
        print()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if let superView = superview {
//            cellSize.constant = superView.frame.size.width / 2
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

}
