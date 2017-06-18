//
//  RangeSliderIndicator.swift
//  RangeSlider
//
//  Created by Ali Ariff on 6/17/17.
//  Copyright © 2017 Ali Ariff. All rights reserved.
//

import Cocoa

class RangeSliderIndicator: NSView {
    private var track : RangeSliderHorizontalTrack?
    private var leftHandle: RangeSliderHandle?
    private var rigthHandle: RangeSliderHandle?
    private var clicked : Bool = false
    private var lastDragLocation : NSPoint?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    init(frame frameRect: NSRect, track trackSlider: RangeSliderHorizontalTrack) {
        super.init(frame: frameRect)
        track = trackSlider
        leftHandle = track?.leftHandle
        rigthHandle = track?.rightHandle
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let w = (rigthHandle?.currentPos?.x)! - (leftHandle?.currentPos?.x)!
        let thisFrame = NSMakeRect((leftHandle?.currentPos?.x)! + 3, (track?.frame.height)!/2 - 10, w, 20)
        setFrameSize(thisFrame.size)
        setFrameOrigin(thisFrame.origin)

        track?.slider?.indicatorColor.set()
        NSRectFill(dirtyRect)
    }

    override func mouseDown(with theEvent: NSEvent) {
        // mouse coordinates within this view's coordinate system
        lastDragLocation = superview!.convert(theEvent.locationInWindow, from: nil)
        clicked = true
    }

    override func mouseUp(with theEvent: NSEvent) {
        clicked = false
    }

    override func mouseDragged(with theEvent: NSEvent) {
        if (clicked) {
            // mouse coordinates within this view's coordinate system
            let newDragLocation = superview!.convert(theEvent.locationInWindow, from:nil)
            let pixelSize = track?.leftHandle?.pixelSize
            let lastValue = Int (Double ((lastDragLocation?.x)! - 20) / pixelSize!)
            let newValue = Int (Double (newDragLocation.x - 20) / pixelSize!)
            let offset = newValue - lastValue
            if (offset == 0) {
                return
            }
            track?.leftHandle?.currentValue += offset
            track?.rightHandle?.currentValue += offset

            needsDisplay = true
            track?.needsDisplay = true

            lastDragLocation = newDragLocation;
        }
    }

}
