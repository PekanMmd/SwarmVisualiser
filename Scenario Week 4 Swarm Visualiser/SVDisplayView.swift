//
//  SVDisplayView.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVDisplayView: NSView {
	
	
	let kWindowTitleHeight : CGFloat = 20
	
	var framePaddingX : CGFloat {
		get {
			return self.frame.width / 100
		}
	}
	
	var framePaddingY : CGFloat {
		get {
			return self.frame.height / 100
		}
	}
	
	let kRobotRadius : CGFloat = 1
	
	var robotDiammeter : CGFloat {
		get {
			return 1 + (2 * kRobotRadius)
		}
	}
	
	var displayFrame  : SVFrame!
	var originalFrame : SVFrame!
	
	var minx : CGFloat = 0
	var miny : CGFloat = 0
	var maxx : CGFloat = 0
	var maxy : CGFloat = 0
	
	var scaleFactorX : SVScaleFactor {
		get {
			return (self.frame.width - (framePaddingX * 2)) / (maxx - minx)
		}
	}
	
	var scaleFactorY : SVScaleFactor {
		get {
			return (self.frame.height - (framePaddingY * 2) - kWindowTitleHeight) / (maxy - miny)
		}
	}
	
	var scaleFactor : SVScaleFactor {
		get {
			return min(scaleFactorX, scaleFactorY)
		}
	}

	
	init(frame: NSRect, svFrame: SVFrame) {
		super.init(frame: frame)
		self.updateWithFrame(frame: svFrame)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidEndLiveResize() {
		self.updateView()
	}
	
	func updateWithFrame(frame: SVFrame) {
		self.originalFrame = frame
		self.updateView()
	}
	
	func updateView() {
		setMinsAndMaxsForFrame(frame: self.originalFrame)
		let scaled = scaleFrame(frame: self.originalFrame)
		self.displayFrame = scaled
		self.setNeedsDisplay(self.frame)
	}
	
	func setMinsAndMaxsForFrame(frame: SVFrame) {
		
		let startRobot = frame.robots[0]
		minx = startRobot.x
		miny = startRobot.y
		maxx = startRobot.x
		maxy = startRobot.y
		
		for robot in frame.robots {
			compareMinMaxForPoint(point: robot)
		}
		
		for obstacle in frame.obstacles {
			for point in obstacle {
				compareMinMaxForPoint(point: point)
			}
		}
		
	}
	
	func compareMinMaxForPoint(point: CGPoint) {
		if point.x < minx {
			minx = point.x
		}
		if point.x > maxx {
			maxx = point.x
		}
		if point.y < miny {
			miny = point.y
		}
		if point.y > maxy {
			maxy = point.y
		}
	}
	
	func scaleFrame(frame: SVFrame) -> SVFrame {
		
		let robots = frame.robots.map({ (p:CGPoint) -> CGPoint in
			scaleCoordinate(coord: p)
		})
		
		let obstacles = frame.obstacles.map { (p: SVPolygon) -> SVPolygon in
			scalePolygon(poly: p)
		}
		
		let lines = frame.lines.map { (e:SVEdge) -> SVEdge in
			(scaleCoordinate(coord: e.0),scaleCoordinate(coord: e.1))
		}
		
		return (robots,obstacles,lines)
	}
	
	func scaleCoordinate(coord: CGPoint) -> CGPoint {
		
		let x = (coord.x - minx) * scaleFactor + framePaddingX
		let y = (coord.y - miny) * scaleFactor + framePaddingY
		
		return CGPoint(x: x, y: y)
	}
	
	func scalePolygon(poly: SVPolygon) -> SVPolygon {
		return poly.map({ (p:CGPoint) -> CGPoint in
			scaleCoordinate(coord: p)
		})
	}
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		
		self.layer?.backgroundColor = SVDesign.colourWhite().cgColor
		
		let context = NSGraphicsContext.current()!.cgContext
		context.clear(self.frame)
		
		drawFrame()
    }
	
	func drawFrame() {
		
		for obstacle in displayFrame.obstacles {
			drawObstacle(obstacle: obstacle, colour: SVDesign.colourRed())
		}
		
		for line in displayFrame.lines {
			drawLine(startx: line.0.x, starty: line.0.y, endx: line.1.x, endy: line.1.y, colour: SVDesign.colourGreen())
		}
		
		for robot in displayFrame.robots {
			
			let zeroPoint = scaleCoordinate(coord: CGPoint(x: 0, y: 0))
			let twPoint = scaleCoordinate(coord: CGPoint(x: 10, y: 10))
			
			if robot.x == zeroPoint.x && robot.y == zeroPoint.y {
				drawRobot(robot: robot, colour: SVDesign.colourGreen())
			} else if robot.x == twPoint.x && robot.y == twPoint.y {
				drawRobot(robot: robot, colour: SVDesign.colourPurple())
			} else {
				drawRobot(robot: robot, colour: SVDesign.colourBlue())
			}
		}
	}
	
	func drawRobot(robot: SVRobotFrame, colour: SVColour) {
		
		let context = NSGraphicsContext.current()!.cgContext
		context.setLineWidth(SVDesign.sizeBorderWidth())
		context.setStrokeColor(colour.cgColor)
		context.setFillColor(colour.cgColor)
		
		context.addRect(CGRect(x: robot.x - kRobotRadius, y: robot.y - kRobotRadius, width: robotDiammeter, height: robotDiammeter))
		context.drawPath(using: .fillStroke)
		
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
			context.drawPath(using: .fillStroke)
			
		}
		
	}
	
}








