//
//  SVProblemSolver.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 21/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVProblemSolver: NSObject {

	var instance : SVInstance!
	var builder : SVPathTableBuilder!
	
	var pathTable = SVPathTable()
	
	init(instance: SVInstance) {
		super.init()
		self.instance = instance
		self.builder = SVPathTableBuilder(instance: instance)
	}
	
//	func createPathTable() {
//		let builder = SVPathTableBuilder()
//		self.pathTable = builder.createTable(instance: self.instance)
//	}
	
	func getShortestPathBetweenTwoCoordinatesFromTable(co1: CGPoint, co2: CGPoint) -> SVPath {
		
		for p in pathTable {
			if (p.0 == co1) && (p.1 == co2) {
				return p.2
			}
		}
		
		let path = builder.pathBetweenPoints(p1: co1, p2: co2)
		
		pathTable.append((co1,co2,path))
		
		return path
	}
	
	func getShortestPathBetweenTwoRobots(r1: SVRobot, r2: SVRobot) -> SVPath {
		return getShortestPathBetweenTwoCoordinatesFromTable(co1: r1.current, co2: r2.current)
	}
	
	func distanceBetweenPoints(p1: CGPoint, p2: CGPoint) -> Double {
		
		let maxx = max(p1.x,p2.x)
		let minx = min(p1.x,p2.x)
		let maxy = max(p1.y,p2.y)
		let miny = min(p1.y,p2.y)
		
		let dx = Double(maxx - minx)
		let dy = Double(maxy - miny)
		
		let dx2 = pow(dx,2)
		let dy2 = pow(dy,2)
		
		return sqrt(dx2 + dy2)
	}
	
	func lengthOfPath(path: SVPath) -> Double {
		
		var length : Double = 0
		
		for i in 0 ..< path.count - 1 {
			length += distanceBetweenPoints(p1: path[i], p2: path[i+1])
		}
		
		return length
	}
	
	func closestRobotTo(robot: SVRobot) -> SVRobot {
		var bots = instance.swarm.sorted { (r1, r2) -> Bool in
			let p1 = getShortestPathBetweenTwoRobots(r1: robot, r2: r1)
			let p2 = getShortestPathBetweenTwoRobots(r1: robot, r2: r2)
			
			return lengthOfPath(path: [robot.current] + p1) < lengthOfPath(path: [robot.current] + p2)
		}
		return bots[0]
	}
	
	func closestInactiveRobotTo(robot: SVRobot) -> SVRobot? {
		
		var bots = instance.swarm.filter { (rob) -> Bool in
			return !rob.isActive
		}
		
		bots = bots.sorted { (r1, r2) -> Bool in
			let p1 = getShortestPathBetweenTwoRobots(r1: robot, r2: r1)
			let p2 = getShortestPathBetweenTwoRobots(r1: robot, r2: r2)
			
			return lengthOfPath(path: p1) < lengthOfPath(path: p2)
		}
		
		if bots.count == 0 {
			return nil
		}
		
		return bots[0]
	}
	
	/* Marathon algorithm

	the starting robot visits each robot
	
	*/
	
	func instanceIsComplete() -> Bool {
		for robot in instance.swarm {
			if !robot.isActive {
				return false
			}
		}
		return true
	}
	
	func marathonAlgorithm() {
		
//		createPathTable()
		
		let runner = instance.swarm[0]
		runner.activate()
		
		while !instanceIsComplete() {
			let closest = closestInactiveRobotTo(robot: runner)
			
			if closest != nil {
				let newPath = runner.path + getShortestPathBetweenTwoRobots(r1: runner, r2: closest!)
				runner.path = newPath
				runner.current = closest!.start
				closest!.activate()
			}
		}
		
	}
	
	/* k-cluster algorithm
	
	let k be the number of clusters
	let n be the number of robots
	
	Gives a sub-optimal solution in O(n^2) time

	1. calculate shortest path from each robot's coordinates to each of the other robots' coordinates in a n x n table
	2. divide map into k x k clusters
	3. starting robot adds closest robot to its path, moves to it and makes it active
	4. for each active robot:
		- if no active robot in its cluster is targeting a robot in a different cluster then target a robot in a different cluster
		- else if there are no inactive or untargeted robots in this cluster and another cluster is untargeted then target closest robot in closest untargeted cluster
		- else if there is an inactive and untargeted robot in this cluster then target the closest one
		- else if it is the closest (active or targeted) robot to an inactive robot in any cluster then target it
	5. for each robot targeting another, add the path to that target to its path, move to the target's position and activate the target.
	6. untarget all robots
	7. repeat until all robots are active
	8. for each robot with a path longer than 1, add its path to the solution
	
	*/
	
	var clusters = [SVCluster]()
	
	func divideIntoKClusters(k: Int) {
		//TODO: implement
	}
	
	func minXForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func minYForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func maxXForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func maxYForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func robot(robot r: SVRobot, isInCluster cluster: SVCluster) {
		//TODO: implement
	}
	
	func robotsInCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func clusterHasBeenTargeted(cluster: SVCluster) {
		//TODO: implement
	}
	
	func robotHasBeenTargeted(robot: SVRobot) {
		//TODO: implement
	}
	
	func clusterHasBeenCompleted(cluster: SVCluster) {
		//TODO: implement
	}
	
	func robot(robot: SVRobot, closestUntargetedRobotInCluster cluster: SVCluster) {
		//TODO: implement
	}
	
	
	func solveByKCluster(k: Int) {
		//TODO: implement
	}
	
	func outputStringForInstance() -> String {
		var output = ""
		for robot in instance.swarm {
			
			if robot.path.count > 1 {
				for point in robot.path {
					output += "(\(point.x), \(point.y)),"
				}
				output = output.substring(to: output.index(before: output.endIndex) )
				output += ";"
			}
			
		}
		output = output.substring(to: output.index(before: output.endIndex) )
		return output
	}
	
	
}
