//
//  TimerView.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 05/05/22.
//

import UIKit



class TimerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    
    //    @IBOutlet weak var timerActionView: UIView!
    @IBOutlet weak var timerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("TimerView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        actionView.layer.cornerRadius = actionView.frame.size.height / 2
    }
    
    
    @IBAction func timerButtonAction(_ sender: Any) {
        print("Hye")
        NotificationCenter.default.post(name: NSNotification.Name("timer"), object: nil)
    }
    
    
}
