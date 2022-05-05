//
//  StoryboardExtension.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit
enum Storyboard: String {
    case authentication
    case home
    case taskDetails
    var name: String {
        return self.rawValue.capitalizingFirstLetter()
    }
}

extension UIViewController {
    static var storyboardId: String {
        return self.className()
    }
}
