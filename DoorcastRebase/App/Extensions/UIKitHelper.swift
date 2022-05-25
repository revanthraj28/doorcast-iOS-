//
//  UIKitHelper.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit

func setSegmentedUI(selectedButton: UIButton, UnSelectButton: UIButton) {
    selectedButton.setTitleColor(UIColor.black, for: [])
    UnSelectButton.setTitleColor(UIColor.white, for: [])
    selectedButton.isUserInteractionEnabled = false
    UnSelectButton.isUserInteractionEnabled = true
//    selectedButton.titleLabel?.font = UIFont.segmentSelectedFont
//    UnSelectButton.titleLabel?.font = UIFont.segmentDeSelectedFont
    selectedButton.addBottomBorderWithColor(color: UIColor.ErrorLabelColor, width: 0.2)
    UnSelectButton.addBottomBorderWithColor(color: UIColor.AppBackgroundColor, width: 0.2)
}
