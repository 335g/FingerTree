//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import XCTest
@testable import FingerTree
import Assertions

final class NodeTests: XCTestCase {
	
	func testNodeSatisfyLawOfSemigroup(){
		// (x + y) + z == x + (y + z)
		
		let entry11 = Entry<Int, String>(1, "a")
		let entry12 = Entry<Int, String>(2, "b")
		let node1 = Node.node2(entry11, entry12)
		
		let entry21 = Entry<Int, String>(3, "c")
		let entry22 = Entry<Int, String>(4, "d")
		let node2 = Node.node2(entry21, entry22)
		
		let entry31 = Entry<Int, String>(5, "e")
		let entry32 = Entry<Int, String>(6, "f")
		let node3 = Node.node2(entry31, entry32)
		
		assertEqual(
			(node1.measure() <> node2.measure()) <> node3.measure(),
			node1.measure() <> (node2.measure() <> node3.measure())
		)
	}
	
	func testStaticNode2ProvidesNodeWithMeasuredValue(){
		let entry1 = Entry<Int, String>(10, "a")
		let entry2 = Entry<Int, String>(20, "b")
		let node = Node.node2(entry1, entry2)
		
		assertEqual(node.measure(), entry1.measure())
	}
	
	func testStaticNode3ProvidesNodeWithMeasuredValue(){
		let entry1 = Entry<Int, String>(10, "a")
		let entry2 = Entry<Int, String>(20, "b")
		let entry3 = Entry<Int, String>(5, "c")
		let node = Node.node3(entry1, entry2, entry3)
		
		assertEqual(node.measure(), entry3.measure())
	}
	
	func testNodeFoldMapMeasureProvidesSelfMeasuredValue(){
		let entry1 = Entry<Int, String>(10, "a")
		let entry2 = Entry<Int, String>(20, "b")
		let entry3 = Entry<Int, String>(5, "c")
		let node = Node.node3(entry1, entry2, entry3)
		
		assertEqual(node.foldMap({ $0.measure() }), node.measure())
	}
}
