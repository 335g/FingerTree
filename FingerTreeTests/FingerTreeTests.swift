//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import XCTest
import Assertions
import Prelude
@testable import FingerTree

final class FingerTreeTests: XCTestCase {
	
	func testFingerTreeEmptyProduceEmpty(){
		let a = FingerTree<Prio<Int, String>, Entry<Int, String>>.empty()
		
		assert(a, ==, .Empty)
	}
	
	func testFingerTreeSingleProduceSingle(){
		let entry = Entry<Int, String>((0, "a"))
		let a = FingerTree<Prio<Int, String>, Entry<Int, String>>.single(entry)
		//let b = FingerTree<Prio<Int, String>, Entry<Int, String>>.Single(entry)
		
		assert(a, ==, .Single(entry))
	}
	
	func testFingerTreeDeepProduceDeep(){
		let entry1 = Entry<Int, String>((0, "a"))
		let entry2 = Entry<Int, String>((1, "b"))
		let a = FingerTree<Prio<Int, String>, Entry<Int, String>>.deep(
			prefix: Digit<Entry<Int, String>>.One(entry1),
			deeper: .Empty,
			suffix: Digit<Entry<Int, String>>.One(entry2)
		)
		
		assert(a, ==, .Deep(.Priority(0, "a"), .One(entry1), .Empty, .One(entry2)))
	}
	
	func testFingerTreeEmptyAppendElemnetProduceSingle(){
		let e = Entry<Int, String>((0, "a"))
		let empty = FingerTree<Prio<Int, String>, Entry<Int, String>>.empty()
		
		let tree1 = empty |> e
		assert(tree1, ==, .Single(e))
		
		let tree2 = e <| empty
		assert(tree2, ==, .Single(e))
	}
	
	func testFingerTreeSingleAppendElementProduceDeep(){
		let e1 = Entry<Int, String>((0, "a"))
		let e2 = Entry<Int, String>((1, "b"))
		let single = FingerTree<Prio<Int, String>, Entry<Int, String>>.single(e1)
		
		let tree1 = single |> e2
		assert(tree1, ==, .Deep(.Priority(0, "a"), .One(e1), .Empty, .One(e2)))

		let tree2 = e2 <| single
		assert(tree2, ==, .Deep(.Priority(0, "a"), .One(e2), .Empty, .One(e1)))
	}
	
	func testFingerTreeDeepAppendElementProduceDeep(){
		let e1 = Entry<Int, String>((0, "a"))
		let e2 = Entry<Int, String>((1, "b"))
		let e3 = Entry<Int, String>((2, "c"))
		let e4 = Entry<Int, String>((3, "d"))
		let e5 = Entry<Int, String>((4, "e"))
		let e6 = Entry<Int, String>((5, "f"))
		
		let single = FingerTree<Prio<Int, String>, Entry<Int, String>>.single(e1)
		let deep = single |> e2
		
		let tree1 = deep |> e3
		assert(tree1, ==, .Deep(.Priority(0, "a"), .One(e1), .Empty, .Two(e2, e3)))

		let tree2 = deep |> e3 |> e4
		assert(tree2, ==, .Deep(.Priority(0, "a"), .One(e1), .Empty, .Three(e2, e3, e4)))
		
		let tree3 = deep |> e3 |> e4 |> e5
		assert(tree3, ==, .Deep(.Priority(0, "a"), .One(e1), .Empty, .Four(e2, e3, e4, e5)))
		
		let tree4: FingerTree<Prio<Int, String>, Entry<Int, String>> = deep |> e3 |> e4 |> e5 |> e6
		let subTree4: FingerTree<Prio<Int, String>, Node<Prio<Int, String>, Entry<Int, String>>> = .Single(Node.node3(e2, e3, e4))
		assert(tree4, ==, .Deep(.Priority(0, "a"), .One(e1), subTree4, .Two(e5, e6)))
		
		let deep2 = e2 <| single
		let tree5 = e3 <| deep2
		assert(tree5, ==, .Deep(.Priority(0, "a"), .Two(e3, e2), .Empty, .One(e1)))

		let tree6 = e4 <| e3 <| deep2
		assert(tree6, ==, .Deep(.Priority(0, "a"), .Three(e4, e3, e2), .Empty, .One(e1)))
		
		let tree7 = e5 <| e4 <| e3 <| deep2
		assert(tree7, ==, .Deep(.Priority(0, "a"), .Four(e5, e4, e3, e2), .Empty, .One(e1)))
		
		let tree8 = e6 <| e5 <| e4 <| e3 <| deep2
		let subTree8: FingerTree<Prio<Int, String>, Node<Prio<Int, String>, Entry<Int, String>>> = .Single(Node.node3(e4, e3, e2))
		assert(tree8, ==, .Deep(.Priority(0, "a"), .Two(e6, e5), subTree8, .One(e1)))
	}
	
	func testFingerTreeUpdateMeasuredValue(){
		let e1 = Entry<Int, String>((0, "a"))
		let e2 = Entry<Int, String>((1, "b"))
		let e3 = Entry<Int, String>((2, "c"))
		let e4 = Entry<Int, String>((3, "d"))
		
		let tree: FingerTree<Prio<Int, String>, Entry<Int, String>> = .Single(e2) |> e3 |> e4
		assert(tree, ==, .Deep(.Priority(1, "b"), .One(e2), .Empty, .Two(e3, e4)))
		
		let tree2 = tree |> e1
		assert(tree2, ==, .Deep(.Priority(0, "a"), .One(e2), .Empty, .Three(e3, e4, e1)))
	}
	
	
}
