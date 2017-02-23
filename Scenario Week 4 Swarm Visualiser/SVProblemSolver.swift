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
	
	func getShortestPathBetweenTwoCoordinatesFromTable(co1: SVPoint, co2: SVPoint) -> SVPath {
		
		if instance.map.count == 0 {
			return [co2]
		}
		
		for p in pathTable {
			if (p.0 == co1) && (p.1 == co2) {
				return p.2
			}
		}
		
		let path = builder.pathBetweenPoints(p1: co1, p2: co2, optimised: true, visited: [co1])
		
		pathTable.append((co1,co2,path))
		
		return path
	}
	
	func getShortestPathBetweenTwoRobots(r1: SVRobot, r2: SVRobot) -> SVPath {
		return getShortestPathBetweenTwoCoordinatesFromTable(co1: r1.current, co2: r2.current)
	}
	
	func distanceBetweenPoints(p1: SVPoint, p2: SVPoint) -> Double {
		
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
	
	func distanceBetweenRobots(r1: SVRobot, r2: SVRobot) -> Double {
		
		let path = [r1.current] + getShortestPathBetweenTwoRobots(r1: r1, r2: r2)
		return lengthOfPath(path: path)
		
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
			let p1 = [robot.current] + getShortestPathBetweenTwoRobots(r1: robot, r2: r1)
			let p2 = [robot.current] + getShortestPathBetweenTwoRobots(r1: robot, r2: r2)
			
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
	
	func runFatBoyRunAlgorithm() {
		
		let runner = instance.swarm[0]
		runner.activate()
		
		while !instanceIsComplete() {
			
			for i in 1 ..< instance.swarm.count {
				
				let target = instance.swarm[i]
				
				let newPath = runner.path + getShortestPathBetweenTwoRobots(r1: runner, r2: target)
				runner.path = newPath
				runner.current = target.start
				target.activate()
				
			}
			
		}
	}
	
	func marathonAlgorithm() {
		
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
		let first = instance.swarm[0]
		
		var minx = first.start.x
		var miny = first.start.y
		var maxx = first.start.x
		var maxy = first.start.y
		
		for robot in instance.swarm {
			if robot.start.x < minx {
				minx = robot.start.x
			}
			if robot.start.x > maxx {
				maxx = robot.start.x
			}
			if robot.start.y < miny {
				miny = robot.start.y
			}
			if robot.start.y > maxy {
				maxy = robot.start.y
			}
		}
		
		let gapx = (maxx - minx) / Double(k)
		let gapy = (maxy - miny) / Double(k)
		
		for i in 0 ..< k {
			for j in 0 ..< k {
				
				let startx = Double(i) * gapx + minx
				let starty = Double(j) * gapy + miny
				
				var endx = startx + gapx
				var endy = starty + gapy
				
				if i == k - 1 {
					endx = maxx + 1
				}
				
				if j == k - 1 {
					endy = maxy + 1
				}
				
				var cluster = SVCluster()
				
				for x in [startx, endx] {
					for y in [starty, endy] {
						cluster.append(SVPoint(x: x, y: y))
					}
				}
				
				clusters.append(cluster)
			}
		}
	}
	
	func minXForCluster(cluster: SVCluster) -> Double {
		return cluster[0].x
	}
	
	func minYForCluster(cluster: SVCluster) -> Double {
		return cluster[0].y
	}
	
	func maxXForCluster(cluster: SVCluster) -> Double {
		return cluster[3].x
	}
	
	func maxYForCluster(cluster: SVCluster) -> Double {
		return cluster[3].y
	}
	
	func robot(robot: SVRobot, isInCluster cluster: SVCluster) -> Bool {
		return (robot.current.x >= minXForCluster(cluster: cluster)) && (robot.current.x < maxXForCluster(cluster: cluster)) && (robot.current.y >= minYForCluster(cluster: cluster)) && (robot.current.y < maxYForCluster(cluster: cluster))
	}
	
	func robotsInCluster(cluster: SVCluster) -> [SVRobot] {
		return instance.swarm.filter({ (rob: SVRobot) -> Bool in
			return robot(robot: rob, isInCluster: cluster)
		})
	}
	
	func clusterForRobot(rob: SVRobot) -> SVCluster {
		for cluster in clusters {
			if robot(robot: rob, isInCluster: cluster) {
				return cluster
			}
		}
		return clusters[0]
	}
	
	func clusterHasBeenTargeted(cluster: SVCluster) -> Bool {
		
		for rob in robotsInCluster(cluster: cluster) {
			if rob.targeted || rob.isActive {
				return true
			}
		}
		
		return false
	}
	
	func clusterHasBeenCompleted(cluster: SVCluster) -> Bool {
		return robotsInCluster(cluster: cluster).filter({ (rob: SVRobot) -> Bool in
			return !rob.isActive
		}).count == 0
	}
	
	func robot(robot: SVRobot, closestUntargetedRobotInCluster cluster: SVCluster) -> SVRobot? {
		var untargeted = robotsInCluster(cluster: cluster).filter { (rob: SVRobot) -> Bool in
			return !rob.targeted && !rob.isActive
		}
		
		if untargeted.count == 0 {
			return nil
		}
		
		untargeted = untargeted.sorted { (r1, r2) -> Bool in
			return distanceBetweenRobots(r1: robot, r2: r1) < distanceBetweenRobots(r1: robot, r2: r2)
		}
		
		return untargeted[0]
	}
	
	func closestUntargetedRobot(robot: SVRobot) -> SVRobot? {
		var untargeted = instance.swarm.filter { (rob: SVRobot) -> Bool in
			return !rob.targeted && !rob.isActive
		}
		
		if untargeted.count == 0 {
			return nil
		}
		
		untargeted = untargeted.sorted { (r1, r2) -> Bool in
			return distanceBetweenRobots(r1: robot, r2: r1) < distanceBetweenRobots(r1: robot, r2: r2)
		}
		
		return untargeted[0]
	}
	
	func closestUntargetedRobotInUntargetedClusterTo(robot: SVRobot) -> SVRobot? {
		var untargeted = instance.swarm.filter { (rob: SVRobot) -> Bool in
			return !rob.targeted && !rob.isActive
		}
		
		if untargeted.count == 0 {
			return nil
		}
		
		untargeted = untargeted.filter { (r) -> Bool in
			return !clusterHasBeenTargeted(cluster:  clusterForRobot(rob: r))
		}
		
		untargeted = untargeted.sorted { (r1, r2) -> Bool in
			return distanceBetweenRobots(r1: robot, r2: r1) < distanceBetweenRobots(r1: robot, r2: r2)
		}
		
		if untargeted.count == 0 {
			return nil
		}
		
		return untargeted[0]
	}
	
	func activeRobots() -> [SVRobot] {
		return instance.swarm.filter({ (r) -> Bool in
			return r.isActive
		})
	}
	
	
	func solveByKCluster(k: Int) {
		
		divideIntoKClusters(k: k)
		
		let starter = instance.swarm[0]
		starter.activate()
		
		let target1 = closestUntargetedRobot(robot: starter)!
		starter.current = target1.current
		starter.path = starter.path + [target1.current]
		target1.activate()
		
		while !instanceIsComplete() {
			
			for roboti in activeRobots() {
				
				let cluster = clusterForRobot(rob: roboti)
				let neighbours = robotsInCluster(cluster: cluster)
				let foreignTargets = neighbours.filter({ (r) -> Bool in
					return (r.isActive) && (r.target != nil)
				}).map({ (r) -> SVRobot in
					return r.target!
				}).filter({ (r) -> Bool in
					return !robot(robot: r, isInCluster: cluster)
				})
				
				if (foreignTargets.count == 0) {
					let target = closestUntargetedRobotInUntargetedClusterTo(robot: roboti)
					if target != nil {
						roboti.target = target
						target!.targeted = true
						continue
					}
				}
				
				if neighbours.filter({ (r) -> Bool in
					return !r.isActive && !r.targeted
				}).count == 0 {
					
					let target = closestUntargetedRobotInUntargetedClusterTo(robot: roboti)
					if target != nil {
						roboti.target = target
						target!.targeted = true
						continue
					}
					
				} else {
					
					let target = robot(robot: roboti, closestUntargetedRobotInCluster: cluster)
					if target != nil {
						roboti.target = target
						target!.targeted = true
						continue
					}
					
				}
				
				for bot in instance.swarm.filter({ (r) -> Bool in
						return !r.isActive && !r.targeted
				}) {
					// if closest to bot then tag it
				}
				
			}
			
			for roboti in instance.swarm  {
				
				if roboti.target != nil {
					let target = roboti.target!
					roboti.current = target.current
					roboti.path = roboti.path + [target.current]
					target.activate()
					target.targeted = false
					roboti.target = nil
				}
			}
			
		}
		
	}
	
	func getAllPoints() -> [String] {
		return SVInputReader.getAllInputPoints(inputFilename: Bundle.main.path(forResource: "input", ofType: "txt") ?? "")
	}
	
	func matchPointFromList(match: Double, points: [String]) -> String {
		for p in points {
			if compareDoubles(d1: match, d2: Double(p)!) {
				return p
			}
		}
		return ""
	}
	
	func outputForInstance() -> SVOutput {
		
		var output = SVOutput()
		
		for robot in instance.swarm {
			
			if robot.path.count > 1 {
				
				output.append(robot.path)
			}
			
		}
		
		return output
		
	}
	
	func optimisedOutputForInstance() -> SVOutput {
		
		let suboptimal = outputForInstance()
		let roboPoints = instance.swarm.map({ (r) -> SVPoint in
			return r.start
		})
		var optimal = SVOutput()
		
		for path in suboptimal {
			
			for point in 0 ..< path.count {
				
				let currentRobot = path[point]
				if !roboPoints.contains(currentRobot) {
					continue
				}
				
				for next in point ..< path.count {
					if roboPoints.contains(path[next]) {
						
						let cornersRange = path[(point + 1) ..< next]
						
						
						
					}
					break
				}
				
			}
			
		}
		
		return optimal
	}
	
	func outputStringForInstance() -> String {
		var output = ""
		let list = getAllPoints()
		
		let outputList = outputForInstance()
		
		for path in outputList {
			
			for point in path {
				
				let x = matchPointFromList(match: point.x, points: list)
				let y = matchPointFromList(match: point.y, points: list)
				
				output += "(\(x), \(y)),"
			}
			output = output.substring(to: output.index(before: output.endIndex) )
			output += ";"
			
		}
		
		output = output.substring(to: output.index(before: output.endIndex) )
		return output
	}
	
	
}
