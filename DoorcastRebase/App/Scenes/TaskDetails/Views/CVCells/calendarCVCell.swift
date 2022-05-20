//
//  calendarCVCell.swift
//  ExStream
//
//  Created by Codebele 05 on 21/01/20.
//  Copyright © 2020 Codebele-01. All rights reserved.
//

import UIKit
import JTAppleCalendar

class calendarCVCell: JTAppleCell {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var holderView: UIView!
        
      override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
      }
      
      func updateFont() {
        label.font = UIFont.poppinsMedium(size: 12)
        holderView.backgroundColor = UIColor.white
    
      }

}
