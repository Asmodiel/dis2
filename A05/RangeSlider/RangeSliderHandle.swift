//
//  RangeSliderHandle.swift
//  RangeSlider
//
//  Created by Ali Ariff on 6/17/17.
//  Copyright © 2017 Ali Ariff. All rights reserved.
//

import Cocoa

class RangeSliderHandle: NSView {
    private var track : RangeSliderHorizontalTrack?
    private var slider : RangeSlider?
    private var clicked : Bool = false
    private var currentPos : NSPoint?
    private var currentValue : Int! = 0
    private var pixelSize : Double = 0.0
    private var symbol : String = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    init(frame frameRect: NSRect, track trackSlider: RangeSliderHorizontalTrack, symbol sym: String) {
        super.init(frame: frameRect)
        track = trackSlider
        slider = track?.slider
        symbol = sym
        currentPos = frame.origin
        if (leftHandle()) {
            currentValue = slider?.leftIndicator
        } else {
            currentValue = slider?.rightIndicator
        }
    }
    
    func calculate() {
        pixelSize = Double ((track?.getTrackLength())!) / Double ((track?.getRangeValue())!)
        let x = CGFloat (currentValue) * CGFloat (pixelSize)
        let y = (slider?.frame.height)! / 2
        let thisOrigin = NSMakePoint(x + 20, y - 10)
        currentPos = thisOrigin
        setFrameOrigin(thisOrigin)
    }
    
    func leftHandle() -> Bool {
        return symbol == "["
    }
    
    func rightHandle() -> Bool {
        return symbol == "]"
    }
    
    func getCurrentPos() -> NSPoint {
        return currentPos!
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        calculate()
        var textColor = NSColor.black
        if (clicked) {
            textColor = NSColor.blue
        }
        let handle = NSString.init(string: symbol)
        let font = NSFont(name: "Helvetica Bold", size: 20.0)
        let textFontAttributes = [
            NSFontAttributeName : font!,
            NSForegroundColorAttributeName: textColor,
        ] as [String : Any]
        handle.draw(at: NSMakePoint(0, 0), withAttributes: textFontAttributes)
        track?.sliderInfo?.needsDisplay = true
        NSDottedFrameRect(dirtyRect)
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        clicked = true
        needsDisplay = true
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        clicked = false
        needsDisplay = true
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
//         mouse coordinates within this view's coordinate system
        let newDragLocation = superview!.convert(theEvent.locationInWindow, from:nil)
        if (clicked && currentValue >= (slider?.minimumValue)! &&
            currentValue <= (slider?.maximumValue)! &&
            (track?.currentMinValue)! <= (track?.currentMaxValue)!) {
            
            needsDisplay = true
            var newValue = Int (Double (newDragLocation.x - 20) / pixelSize)
            newValue = max((slider?.minimumValue)!, newValue)
            newValue = min((slider?.maximumValue)!, newValue)
            
            if (leftHandle() && newValue < (track?.currentMaxValue)!) {
                track?.currentMinValue = newValue
                currentValue = newValue
            } else if (rightHandle() && newValue > (track?.currentMinValue)!) {
                track?.currentMaxValue = newValue
                currentValue = newValue
            }
        }
    }
}
