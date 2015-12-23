//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Foundation
@testable import FingerTree

enum Entry<V: Comparable, A> {
	case Ent(V, A)
	
	init(_ v: V, _ a: A){
		self = .Ent(v, a)
	}
}

enum Priority<V: Comparable, A> {
	case NoPrio
	case Prio(V, A)
}

extension Priority: Monoid {
	static var mempty: Priority { return .NoPrio }
	func mappend(other: Priority) -> Priority {
		switch (self, other) {
		case let (x, .NoPrio):
			return x
		case let (.NoPrio, x):
			return x
		case let (.Prio(kx, _), .Prio(ky, _)):
			if kx <= ky {
				return self
			}else {
				return other
			}
		default:
			fatalError()
		}
	}
}

extension Entry: Measurable {
	typealias MeasuredValue = Priority<V, A>
	func measure() -> MeasuredValue {
		switch self {
		case let .Ent(v, a):
			return .Prio(v, a)
		}
	}
}

func == <V, A: Equatable>(lhs: Priority<V, A>, rhs: Priority<V, A>) -> Bool {
	switch (lhs, rhs) {
	case (.NoPrio, .NoPrio):
		return true
	case let (.Prio(v1, a1), .Prio(v2, a2)):
		return v1 == v2 && a1 == a2
	default:
		return false
	}
}