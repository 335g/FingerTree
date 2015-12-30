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

struct PQueue<K: Comparable, V>: Monoid {
	let queue: FingerTree<Prio<K, V>, Entry<K, V>>
	
	init(_ x: FingerTree<Prio<K, V>, Entry<K, V>>){
		queue = x
	}
}

extension PQueue {
	static var mempty: PQueue {
		return PQueue<K, V>.empty()
	}
	
	func mappend(other: PQueue) -> PQueue {
		return self.union(other)
	}
}

extension PQueue {
	static func empty() -> PQueue {
		return PQueue<K, V>(FingerTree.empty())
	}
	
	func union(other: PQueue) -> PQueue {
		return PQueue(self.queue.append(other.queue))
	}
}