//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import XCTest
@testable import FingerTree

final class NodeTests: XCTestCase {
	
	func testStaticNode2ProvidesNodeWithMeasuredValue(){
		let entry1 = Entry<Int, String>(10, "a")
		let entry2 = Entry<Int, String>(20, "b")
		let node = Node.node2(entry1, entry2)
		
		XCTAssertEqual(node.measure(), entry1.measure(), "")
	}
}
