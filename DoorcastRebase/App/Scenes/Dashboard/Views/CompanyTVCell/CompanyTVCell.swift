//
//  CompanyTVCell.swift
//  DoorcasrRebase
//
//  Created by Codebele-09 on 04/05/22.
//  Copyright © 2021 Codebele-09. All rights reserved.
//

import UIKit

class CompanyTVCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateFontAndColors()
        
   
        holderView.backgroundColor = UIColor.white
        holderView.layer.shadowOpacity = 0.3
        holderView.layer.shadowOffset = CGSize.zero
        holderView.layer.borderColor = UIColor.darkGray.cgColor
        holderView.layer.borderWidth = 0.2
        holderView.layer.cornerRadius = 5
        
             
    }
    
    func updateFontAndColors(){
        titleLabel.font = UIFont.oswaldMedium(size: 22)
        arrowImageView.image = UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = .darkGray
        titleLabel.textColor = UIColor.LabelMainTitleColor
             
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
    
}
