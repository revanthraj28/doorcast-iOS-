//
//  TableViewHelper.swift
//  DoorcastRebase
//
//  Created by CODEBELE-01 on 11/05/22.
//

import Foundation
import UIKit



extension UIViewController {
    
    class TableViewHelper {
        
        class func EmptyMessage(message:String, tableview:UITableView,vc:UIViewController) {
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: vc.view.bounds.size.width, height: vc.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = message
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()
            
            tableview.backgroundView = messageLabel;
            tableview.separatorStyle = .none;
        }
    }
}
