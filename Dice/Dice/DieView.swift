//
//  DieView.swift
//  Dice
//
//  Created by Sinkerine on 19/01/2017.
//  Copyright © 2017 sinkerine. All rights reserved.
//

import Cocoa

class DieView: NSView {
    
    var intValue: Int? = 1 {
        didSet {
            needsDisplay = true
        }
    }
    
    var pressed: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 20, height: 20)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let backgroundColor = NSColor.lightGray
        backgroundColor.set()
        NSBezierPath.fill(bounds)
        
        drawDieWithSize(size: bounds.size)
    }
    
    func metricsFor(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength / 10.0
        let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
        let dieFrame = !pressed ? drawingBounds.insetBy(dx: padding, dy: padding) : drawingBounds.insetBy(dx: 0, dy: -edgeLength / 40)
        return (edgeLength, dieFrame)
    }
    
    func drawDieWithSize(size: CGSize) {
        if let intValue = intValue {
            let (edgeLength, dieFrame) = metricsFor(size: size)
            let dotRadius = edgeLength / 12.0
            let dotFrame = dieFrame.insetBy(dx: dotRadius * 2.5, dy: dotRadius * 2.5)
            NSGraphicsContext.saveGraphicsState()
            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 0, height: -1)
            shadow.shadowBlurRadius = pressed ? edgeLength / 100 : edgeLength / 20
            shadow.set()
            let cornerRadius: CGFloat = edgeLength / 5.0
            // Draw the rounded shape of the dir profile:
            NSColor.white.set()
            NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
            NSGraphicsContext.restoreGraphicsState()
            
            // Ready to draw the dots
            NSColor.black.set()
            
            // Nested function to make drawing dots cleaner:
            func drawDot(u: CGFloat, v: CGFloat) {
                let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.width * u, y: dotFrame.minY + dotFrame.height * v)
                let dotRect = CGRect(origin: dotOrigin, size: CGSize.zero).insetBy(dx: -dotRadius, dy: -dotRadius)
                NSBezierPath(ovalIn: dotRect).fill()
            }
            if intValue == 1 || intValue == 3 || intValue == 5 {
                drawDot(u: 0.5, v: 0.5)
            }
            if intValue >= 2 && intValue <= 6 {
                drawDot(u: 0, v: 1)
                drawDot(u: 1, v: 0)
            }
            if intValue >= 4 && intValue <= 6 {
                drawDot(u: 1, v: 1)
                drawDot(u: 0, v: 0)
            }
            if intValue == 6 {
                drawDot(u: 1, v: 0.5)
            }
        }
    }
    
    func randomize() {
            intValue = Int(arc4random_uniform(5)) + 1
    }
    
    override func mouseUp(with event: NSEvent) {
        if event.clickCount == 2{
            randomize()
        }
        pressed = false
    }
    
    override func mouseDown(with event: NSEvent) {
        let dieFrame = metricsFor(size: bounds.size).dieFrame
        let pointInview = convert(event.locationInWindow, from: nil)
        pressed = dieFrame.contains(pointInview)
    }
}
