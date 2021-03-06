//
//  RangeSliderHorizontalTrack.swift
//  RangeSlider
//
//  DIS II Group 7
//  Ali Ariff, Andi Heynoum Dala Rifat, Zain Ahmed S.
//
//  Created by Ali Ariff on 6/17/17.
//  Copyright © 2017 Ali Ariff. All rights reserved.
//

import Cocoa

class RangeSliderHorizontalTrack: NSView {
    public var slider : RangeSlider?
    public var leftHandle : RangeSliderHandle?
    public var rightHandle : RangeSliderHandle?
    public var sliderInfo : RangeSliderInfo?
    public var indicator : RangeSliderIndicator?
    public var currentMinValue : Int!
    public var currentMaxValue : Int!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    init(frame frameRect: NSRect, slider rangeSlider: RangeSlider) {
        super.init(frame: frameRect)
        slider = rangeSlider
        // create left and right handle
        leftHandle = RangeSliderHandle(frame: NSMakeRect(0, 0, 10, 20), track: self, symbol: "[")
        rightHandle = RangeSliderHandle(frame: NSMakeRect(0, 0, 10, 20), track: self, symbol: "]")
        // create the sliderInfo which contains label to show the current value from leftHandle and rightHandle
        sliderInfo = RangeSliderInfo(frame: NSMakeRect(0, frame.height/2 - 50, frame.width, 100), track: self)
        // create the indicatior that shows the covered range area as well as leftHandle and rightHandle (e.g area with orange color in the example)
        indicator = RangeSliderIndicator(frame: NSMakeRect(15, frame.height/2 - 15, frame.width - 30, 30), track: self)

        // add all of the objects as subview of horizontalTrack
        self.addSubview(sliderInfo!)
        self.addSubview(indicator!)
        self.addSubview(leftHandle!)
        self.addSubview(rightHandle!)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // initialize variable and value needed to draw horizontalTrack
        let horizontalTrack = NSBezierPath()
        let w = frame.width
        let h = frame.height / 2
        let offset: CGFloat = 6.0
        let min: Int = (slider?.minimumValue)!
        let max: Int = (slider?.maximumValue)!
        let minValue: NSString = NSString.init(string: "\(min)")
        let maxValue: NSString = NSString.init(string: "\(max)")
        let minValuePoint = CGPoint(x: 0, y: h - offset)
        let maxValuePoint = CGPoint(x: w - 20, y: h - offset)

        // draw min and max value at the end of the line
        minValue.draw(at: minValuePoint)
        maxValue.draw(at: maxValuePoint)

        // draw the horizontal line
        horizontalTrack.lineWidth = 2.0
        horizontalTrack.move(to: CGPoint(x: 20, y: h))
        horizontalTrack.line(to: CGPoint(x: w - 30, y: h))
        slider?.lineColor.set()
        horizontalTrack.close()
        horizontalTrack.stroke()
        horizontalTrack.fill()

        // NSDottedFrameRect(dirtyRect)

        autoResize()

        // redraw
        leftHandle?.needsDisplay = true
        rightHandle?.needsDisplay = true
        sliderInfo?.needsDisplay = true
    }

    func autoResize() {
        // handle when resizing window happen
        leftHandle?.calculate()
        rightHandle?.calculate()

        let sliderFrame = NSMakeRect(0, frame.height/2 - 50, frame.width, 100)
        let w = (rightHandle?.currentPos?.x)! - (leftHandle?.currentPos?.x)!
        let indicatorFrame = NSMakeRect((leftHandle?.currentPos?.x)! + 3, (frame.height)/2 - 10, w, 20)

        sliderInfo?.setFrameSize(sliderFrame.size)
        sliderInfo?.setFrameOrigin(sliderFrame.origin)
        indicator?.setFrameSize(indicatorFrame.size)
        indicator?.setFrameOrigin(indicatorFrame.origin)
    }

    func getTrackLength() -> Int {
        // substract with left and right offset
        return Int (slider!.frame.width - CGFloat (50))
    }

    func getRangeValue() -> Int {
        return (slider?.maximumValue)! - (slider?.minimumValue)!
    }

}
