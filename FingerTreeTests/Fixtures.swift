//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Prelude
@testable import FingerTree

struct Entry<K: Comparable, V>: Measurable {
	let entry: (K, V)
	init(_ x: (K, V)){
		entry = x
	}
}

extension Entry {
	func measure() -> Prio<K, V> {
		return .Priority(entry.0, entry.1)
	}
}

enum Prio<K: Comparable, V>: Monoid {
	case NoPriority
	case Priority(K, V)
}

extension Prio {
	static var mempty: Prio {
		return .NoPriority
	}
	
	func mappend(other: Prio) -> Prio {
		switch (self, other) {
		case (.NoPriority, .NoPriority):
			return self
		case (.NoPriority, .Priority(_)):
			return other
		case (.Priority(_), .NoPriority):
			return self
		case let (.Priority(kx, _), .Priority(ky, _)):
			if kx <= ky {
				return self
			}else {
				return other
			}
		}
	}
}

func == <K, V: Equatable>(lhs: Entry<K, V>, rhs: Entry<K, V>) -> Bool {
	return lhs.entry.0 == rhs.entry.0 && lhs.entry.1 == rhs.entry.1
}

func == <K, V: Equatable>(lhs: FingerTree<Prio<K, V>, Entry<K, V>>, rhs: FingerTree<Prio<K, V>, Entry<K, V>>) -> Bool {
	let l = lhs.list
	let r = rhs.list
	
	if l.count != r.count {
		return false
	}
	
	let zipped = zip(l, r)
	return zipped.reduce(true){ $0 && ($1.0 == $1.1) }
}

func == <K, V: Equatable>(lhs: Prio<K, V>, rhs: Prio<K, V>) -> Bool {
	switch (lhs, rhs) {
	case (.NoPriority, .NoPriority):
		return true
	case (.NoPriority, .Priority(_, _)):
		return false
	case (.Priority(_, _), .NoPriority()):
		return false
	case let (.Priority(k1, v1), .Priority(k2, v2)):
		return k1 == k2 && v1 == v2
	}
}