//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Foundation
@testable import FingerTree

enum Entry<V: Comparable, A> {
	case Ent(V, A)
}

enum Priority<K: Comparable, V> {
	case NoPrio
	case Prio(K, V)
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