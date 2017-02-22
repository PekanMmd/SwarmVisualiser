//
//  SVPathTableBuilder.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 22/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVPathTableBuilder: NSObject {
	
	let table = SVPathTable()
	
	func edgesFromPolygon(polygon: SVPolygon) -> [SVEdge] {
		var edges = [SVEdge]()
		for i in 0 ..< polygon.count - 1 {
			edges.append((polygon[i],polygon[i+1]))
		}
		edges.append((polygon.last!,polygon.first!))
		return edges
	}
	
	func edgesFromMap(map: SVMap) -> [SVEdge] {
		var edges = [SVEdge]()
		
		for obstacle in map {
			edges += edgesFromPolygon(polygon: obstacle)
		}
		
		return edges
	}
	
	func pointsFromEdge(edge: SVEdge) -> [CGPoint] {
		return [edge.0,edge.1]
	}
	
	func minMaxXForEdge(edge: SVEdge) -> (CGFloat, CGFloat) {
		let minx = min(edge.0.x, edge.1.x)
		let maxx = max(edge.0.x, edge.1.x)
		return (minx,maxx)
	}
	
	func lineIsHorizontal(line: SVEdge) -> Bool {
		return line.0.y == line.1.y
	}
	
	func lineIsVertical(line: SVEdge) -> Bool {
		return line.0.x == line.1.x
	}
	
//	func doesLineIntersectVerticalLine(line: SVEdge, edge: SVEdge) -> Bool {
//		
//		let minEdgeY = min(edge.0.y,edge.1.y)
//		let maxEdgeY = max(edge.0.y,edge.1.y)
//		
//		let minLineX = min(edge.0.x,edge.1.x)
//		let maxLineX = max(edge.0.x,edge.1.x)
//		
//		let minLineY = min(edge.0.y,edge.1.y)
//		let maxLineY = max(edge.0.y,edge.1.y)
//		
//		if (minLineX < edge.0.x) && (edge.0.x < maxLineX) {
//			if  line.0.y < line.1.y {
//				
//			}
//		}
//		
//		return false
//	}
	
	func doesLine(line: SVEdge, intersectEdge edge: SVEdge) -> Bool {
		
		if lineIsVertical(line: line) {
			
		}
		
		let I1 = minMaxXForEdge(edge: line)
		let I2 = minMaxXForEdge(edge: edge)
		
		let Ia = ( max(I1.0, I2.0), min(I1.1, I2.1) )
		
		if max(line.0.x, line.1.x) < min(edge.0.x, edge.1.x) {
			return false
		}
		
		if max(edge.0.x, edge.1.x) < min(line.0.x, line.1.x) {
			return false
		}
		
		
		return false
	}
	
	func edgesIntersectedByLineBetweenPoints(line: SVEdge) -> [SVEdge]? {
		return nil
	}
	
	func lineBetweenPointsClosestPointFromIntersectedEdges(p1: CGPoint, p2: CGPoint) -> CGPoint? {
		return nil
	}
	
	func createTable(instance: SVInstance) {
		
		
		
		
		
		
	}

}
