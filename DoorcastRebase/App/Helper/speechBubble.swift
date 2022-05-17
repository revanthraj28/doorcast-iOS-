//
//  speechBubble.swift
//  ExStream
//
//  Created by Codebele 05 on 22/01/20.
//  Copyright © 2020 Codebele-01. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SpeechBubble: UIView {
    
    var color:UIColor = UIColor.ThemeColor
    
    override func draw(_ rect: CGRect) {
        
        let rounding:CGFloat = rect.width * 0.04
        
        //Draw the main frame
        
        let bubbleFrame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 2 / 3)
        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: rounding, height: rounding))
        
        //Color the bubbleFrame
        
        color.setStroke()
        color.setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        //Add the point
        
        let context = UIGraphicsGetCurrentContext()
        
        //Start the line
        
        context!.beginPath()
        //        CGContextMoveToPoint(context, bubbleFrame.minX + bubbleFrame.width * 1/3, bubbleFrame.maxY)
        context!.move(to: CGPoint(x: rect.midX - 10, y: bubbleFrame.maxY))
        
        //Draw a rounded point
        
        //        CGContextAddArcToPoint(context, rect.maxX * 1/3, rect.maxY, bubbleFrame.maxX, bubbleFrame.minY, rounding)
        
        context!.addArc(tangent1End: CGPoint(x: rect.maxX * 1 / 2, y: rect.maxY), tangent2End: CGPoint(x: bubbleFrame.maxX, y: bubbleFrame.minY), radius: rounding)        //Close the line
        
        //        CGContextAddLineToPoint(context, bubbleFrame.minX + bubbleFrame.width * 2/3, bubbleFrame.maxY)
        context!.addLine(to: CGPoint(x: bubbleFrame.midX + 10, y: bubbleFrame.maxY))
        context!.closePath()
        
        //fill the color
        
        context!.setFillColor(color.cgColor)
        context!.fillPath();
    }
}
