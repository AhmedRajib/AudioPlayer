//
//  TableViewCellExtensions.swift
//  AudioProject
//
//  Created by ahmed rajib on 22/11/23.
//

import Foundation
import UIKit

extension UITableViewCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
