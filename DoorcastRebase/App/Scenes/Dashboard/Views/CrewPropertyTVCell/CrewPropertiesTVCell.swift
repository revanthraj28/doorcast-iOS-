//
//  CrewPropertiesTVCell.swift
//  ExStream
//
//  Created by Codebele 05 on 11/05/20.
//  Copyright © 2020 Codebele-01. All rights reserved.
//

import UIKit

class CrewPropertiesTVCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        lbl_PropertiesValue.textColor = .black
        lbl_PropertiesValue.numberOfLines = 0
        lbl_PropertiesValue.textAlignment = .center
        
        lineView.backgroundColor = .lightGray
        
        btn_checked.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_checked.imageView?.tintColor = .white
        btn_checked.backgroundColor = .clear
        btn_checked.imageView?.backgroundColor = .clear
        
        
        PropertiesHolderView.backgroundColor = .white
        
        btn_checked.isHidden = true
    }
    
    
    @IBOutlet weak var btn_checked: UIButton!
    @IBOutlet weak var PropertiesHolderView: UIView!
    @IBOutlet weak var lbl_PropertiesValue: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        
    }
    
}
