//
//  DeleteCellDelegate.swift
//  AlefTest
//
//  Created by  Егор Шуляк on 22.02.22.
//

import Foundation
import UIKit

protocol DeleteCellDelegate {
    func deleteCell(cell: UITableViewCell)
    func saveCell(cell: UITableViewCell)
}
