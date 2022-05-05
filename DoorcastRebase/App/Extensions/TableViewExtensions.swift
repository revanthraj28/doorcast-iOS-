//
//  TableViewExtensions.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit
//MARK:- UITableViewCell Extensions
extension UITableViewCell {
    static var cellId: String {
        return String(describing: self.self)
    }
    
    static var cellNib: UINib {
        return UINib(nibName: cellId, bundle: nil)
    }
}
