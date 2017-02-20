//
//  SVDisplayView.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVDisplayView: NSView {
	
	var displayFrame : SVFrame!
	
	init(frame: SVFrame) {
		super.init(frame: NSZeroRect)
		self.displayFrame = frame
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func updateWithFrame(frame: SVFrame) {
		self.displayFrame = frame
		self.needsDisplay = true
	}
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		drawFrame()
    }
	
	func drawFrame() {
		 drawLine(startx: 0, starty: 0, endx: 250, endy: 250, colour: SVDesign.colourRed())
	}
	
	func drawRobot(robot: SVRobotFrame, colour: SVColour) {
		
	}
	
	func drawObstacle(obstacle: SVObstacleFrame, colour: SVColour) {
		
	}
	
	func drawLine(startx x1: CGFloat, starty y1: CGFloat, endx x2: CGFloat, endy y2: CGFloat, colour: SVColour) {
		
		let start = CGPoint(x: x1, y: y1)
		let end = CGPoint(x: x2, y: y2)
		
		let context = NSGraphicsContext.current()!.cgContext
		context.setLineWidth(3.0)
		context.setStrokeColor(colour.cgColor)
		
		context.move(to: start)
		context.addLine(to: end)
		
		context.strokePath()
	}
	
	func drawPolygon(polygon: SVPolygon, lineColour: SVColour, fillColour: SVColour) {
		
	}
	
}








