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
//		drawLine(startx: 100, starty: 100, endx: 250, endy: 250, colour: SVDesign.colourRed())
//		drawRobot(robot: CGPoint(x:150,y:325), colour: SVDesign.colourBlue())
//		let shape = [(100,100),(120,120),(140,100)].map { (coords: (Int, Int)) -> CGPoint in
//			return CGPoint(x: coords.0, y: coords.1)
//		}
//		drawPolygon(polygon: shape, lineColour: SVDesign.colourBlack(), fillColour: SVDesign.colourGreen())
		
		for obstacle in displayFrame.obstacles {
			drawObstacle(obstacle: obstacle, colour: SVDesign.colourRed())
		}
		
		for robot in displayFrame.robots {
			drawRobot(robot: robot, colour: SVDesign.colourBlue())
		}
	}
	
	func drawRobot(robot: SVRobotFrame, colour: SVColour) {
		
		let context = NSGraphicsContext.current()!.cgContext
		context.setLineWidth(SVDesign.sizePointWidth())
		context.setStrokeColor(colour.cgColor)
		context.setFillColor(colour.cgColor)
		
		context.addRect(CGRect(x: robot.x - 1, y: robot.y - 1, width: 3, height: 3))
//		context.strokePath()
		context.fillPath()
		
	}
	
	func drawObstacle(obstacle: SVObstacleFrame, colour: SVColour) {
		
		drawPolygon(polygon: obstacle, lineColour: SVDesign.colourBlack(), fillColour: colour)
		
	}
	
	func drawLine(startx x1: CGFloat, starty y1: CGFloat, endx x2: CGFloat, endy y2: CGFloat, colour: SVColour) {
		
		let start = CGPoint(x: x1, y: y1)
		let end = CGPoint(x: x2, y: y2)
		
		let context = NSGraphicsContext.current()!.cgContext
		context.setLineWidth(SVDesign.sizeLineWidth())
		context.setStrokeColor(colour.cgColor)
		
		context.move(to: start)
		context.addLine(to: end)
		
		context.strokePath()
	}
	
	func drawPolygon(polygon: SVPolygon, lineColour: SVColour, fillColour: SVColour) {
		
		if polygon.count > 0 {
			
			let context = NSGraphicsContext.current()!.cgContext
			context.setLineWidth(SVDesign.sizeBorderWidth())
			context.setStrokeColor(lineColour.cgColor)
			context.setFillColor(fillColour.cgColor)
			
			context.move(to: polygon[0])
			
			for i in 1 ..< polygon.count {
				context.addLine(to: polygon[i])
			}
			
			context.closePath()
			context.fillPath()
//			context.strokePath()
			
		}
		
	}
	
}








