//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import XCTest
@testable import FingerTree
import Assertions

final class NodeTests: XCTestCase {
	
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
}
