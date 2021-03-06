//
//  SVDisplayView.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVDisplayView: NSView {
	
	var frameNumber = 0
	
	
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
		self.frameNumber += 1
	}
	
	func updateView() {
		setMinsAndMaxsForFrame(frame: self.originalFrame)
		let scaled = scaleFrame(frame: self.originalFrame)
		self.displayFrame = scaled
		self.setNeedsDisplay(self.frame)
	}
	
	func setMinsAndMaxsForFrame(frame: SVFrame) {
		
		let startRobot = frame.robots[0]
		minx = CGFloat(startRobot.point.x)
		miny = CGFloat(startRobot.point.y)
		maxx = CGFloat(startRobot.point.x)
		maxy = CGFloat(startRobot.point.y)
		
		for robot in frame.robots {
			compareMinMaxForPoint(point: robot.point)
		}
		
		for obstacle in frame.obstacles {
			for point in obstacle {
				compareMinMaxForPoint(point: point)
			}
		}
		
	}
	
	func compareMinMaxForPoint(point: SVPoint) {
		if CGFloat(point.x) < minx {
			minx = CGFloat(point.x)
		}
		if CGFloat(point.x) > maxx {
			maxx = CGFloat(point.x)
		}
		if CGFloat(point.y) < miny {
			miny = CGFloat(point.y)
		}
		if CGFloat(point.y) > maxy {
			maxy = CGFloat(point.y)
		}
	}
	
	func scaleFrame(frame: SVFrame) -> SVFrame {
		
		let robots = frame.robots.map({ (p:SVRobotFrame) -> SVRobotFrame in
			(scaleCoordinate(coord: p.point),p.isActive,p.index)
		})
		
		let obstacles = frame.obstacles.map { (p: SVPolygon) -> SVPolygon in
			scalePolygon(poly: p)
		}
		
		let lines = frame.lines.map { (e:SVEdge) -> SVEdge in
			(scaleCoordinate(coord: e.0),scaleCoordinate(coord: e.1))
		}
		
		return (robots,obstacles,lines)
	}
	
	func scaleCoordinate(coord: SVPoint) -> SVPoint {
		
		let x = (CGFloat(coord.x) - minx) * scaleFactor + framePaddingX
		let y = (CGFloat(coord.y) - miny) * scaleFactor + framePaddingY
		
		return SVPoint(x: Double(x), y: Double(y))
	}
	
	func scalePolygon(poly: SVPolygon) -> SVPolygon {
		return poly.map({ (p:SVPoint) -> SVPoint in
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
			drawObstacle(obstacle: obstacle, colour: SVDesign.colourBlur())
		}
		
		for line in displayFrame.lines {
			drawLine(startx: CGFloat(line.0.x), starty: CGFloat(line.0.y), endx: CGFloat(line.1.x), endy: CGFloat(line.1.y), colour: SVDesign.colourGreen())
		}
		
		let colours = [SVDesign.colourRed(),SVDesign.colourOrange(),SVDesign.colourYellow(),SVDesign.colourGreen(),SVDesign.colourBlue(),SVDesign.colourPurple()]
		
		for robot in displayFrame.robots {
			let colour = colours[robot.index % colours.count]
			if robot.isActive {
				drawRobot(robot: robot, colour: colour)
			} else {
				drawRobot(robot: robot, colour: SVDesign.colourGrey())
			}
			
		}
	}
	
	func drawRobot(robot: SVRobotFrame, colour: SVColour) {
		
		let context = NSGraphicsContext.current()!.cgContext
		context.setLineWidth(SVDesign.sizeBorderWidth())
		context.setStrokeColor(colour.cgColor)
		context.setFillColor(colour.cgColor)
		
		
		if robot.isActive && (frameNumber % 10 > 5) {
			let poly = [SVPoint(x: robot.point.x - Double(kRobotRadius), y: robot.point.y),
			            SVPoint(x: robot.point.x, y: robot.point.y + Double(kRobotRadius)),
			            SVPoint(x: robot.point.x + Double(kRobotRadius), y: robot.point.y),
			            SVPoint(x: robot.point.x, y: robot.point.y - Double(kRobotRadius))]
			
			drawPolygon(polygon: poly, lineColour: colour, fillColour: colour)
		} else {
			context.addRect(CGRect(x: CGFloat(robot.point.x) - kRobotRadius, y: CGFloat(robot.point.y) - kRobotRadius, width: robotDiammeter, height: robotDiammeter))
			context.drawPath(using: .fillStroke)
			
		}
		
		
		
		
		
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
			
			context.move(to: polygon[0].toCGPoint)
			
			for i in 1 ..< polygon.count {
				context.addLine(to: polygon[i].toCGPoint)
			}
			
			context.closePath()
			context.drawPath(using: .fillStroke)
			
		}
		
	}
	
}








