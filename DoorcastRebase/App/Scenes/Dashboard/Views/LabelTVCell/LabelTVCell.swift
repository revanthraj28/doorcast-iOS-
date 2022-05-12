//
//  LabelTVCell.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 06/05/22.
//

import UIKit

class LabelTVCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var commomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
     commomLabel.font = UIFont.oswaldMedium(size: 14)
     commomLabel.textColor = .black
     checkImage.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
