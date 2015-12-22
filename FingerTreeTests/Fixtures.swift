//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Foundation
@testable import FingerTree

struct Priority {
	let getPriority: UInt
	
	init(_ priority: UInt) {
		self.getPriority = priority
	}
}

extension Priority: Monoid {
	static var mempty: Priority {
		return Priority(0)
	}
	
	func mappend(other: Priority) -> Priority {
		return self.getPriority > other.getPriority ? self : other
	}
}

struct MyString {
	let string: String
	let priority: Priority
	
	init(_ str: String, _ priority: Priority){
		self.string = str
		self.priority = priority
	}
}

extension MyString: Measurable {
	typealias MeasuredValue = Priority
	
	func measure() -> MeasuredValue {
		return priority
	}
}

extension MyString: CustomDebugStringConvertible {
	var debugDescription: String {
		return string + "(" + String(priority.getPriority) + ")"
	}
}