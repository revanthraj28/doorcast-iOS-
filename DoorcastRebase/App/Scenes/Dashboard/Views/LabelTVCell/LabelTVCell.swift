//
//  LabelTVCell.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 06/05/22.
//

import UIKit

class LabelTVCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var commomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
