//
//  TaskAssignedTVCell.swift
//  ExStream
//
//  Created by Codebele 06 on 08/03/22.
//  Copyright © 2022 Codebele-01. All rights reserved.
//

import UIKit

class TaskAssignedTVCell: UITableViewCell {
    @IBOutlet weak var newTaskLabel: UILabel!
    
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var fowardButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var newTaskImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI()
    {
        holderView.layer.cornerRadius = 3
        replyButton.titleLabel?.font = UIFont.oswaldRegular(size: 17)
     
        
    }
    
    
}
