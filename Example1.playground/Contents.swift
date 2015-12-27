
import FingerTree

//
// Example(1) Priority Queue
//   reference (https://hackage.haskell.org/package/fingertree-0.1.1.0/docs/Data-PriorityQueue-FingerTree.html)
//

enum Ent<V: Equatable>: Equatable {
	case Entry(UInt, V)
}

func == <V: Equatable> (lhs: Ent<V>, rhs: Ent<V>) -> Bool {
	switch (lhs, rhs) {
	case let (.Entry(p1, v1), .Entry(p2, v2)):
		return p1 == p2 && v1 == v2
	}
}

enum Prio<V: Equatable>: Equatable {
	case NoPriority
	case Priority(UInt, V)
}

func == <V: Equatable> (lhs: Prio<V>, rhs: Prio<V>) -> Bool {
	switch (lhs, rhs) {
	case (.NoPriority, .NoPriority):
		return true
	case let (.Priority(p1, v1), .Priority(p2, v2)):
		return p1 == p2 && v1 == v2
	default:
		return false
	}
}

extension Prio: Monoid {
	static var mempty: Prio { return .NoPriority }
	func mappend(other: Prio) -> Prio {
		switch (self, other) {
		case (.NoPriority, .NoPriority):
			return .NoPriority
		case (.NoPriority, .Priority(_)):
			return other
		case (.Priority(_), .NoPriority):
			return self
		case let (.Priority(x, _), .Priority(y, _)):
			if x <= y {
				return self
			}else {
				return other
			}
		}
	}
}

extension Ent: Measurable {
	typealias MeasuredValue = Prio<V>
	func measure() -> Prio<V> {
		switch self {
		case let .Entry(p, v):
			return .Priority(p, v)
		}
	}
}

class PriorityQueue<V: Equatable> {
	var tree: FingerTree<Prio<V>, Ent<V>>
	
	init(_ ent: Ent<V>){
		self.tree = FingerTree.single(ent)
	}
	
	func add(ent: Ent<V>) {
		self.tree = tree |> ent
	}
	
	var highestPriorityEntry: Ent<V>? {
		switch self.measure() {
		case .NoPriority:
			return nil
			
		case let .Priority(p, v):
			return .Entry(p, v)
		}
	}
	
//	var minView: (V, PriorityQueue)? {
//		
//	}
	
	var minViewWithKey: ((UInt, V), PriorityQueue)? {
		switch tree {
		case .Empty:
			return nil
			
		default:
			let prio = tree.measure()
			switch prio {
			case let .Priority(k, v):
				switch tree.split({ p in
					switch p {
				case .NoPriority:
					return false
				case let .Priority(k_, _):
					return k_ <= k
					}
				})
			}
		}
	}
}

extension PriorityQueue: Measurable {
	typealias MeasuredValue = Prio<V>
	func measure() -> Prio<V> {
		return tree.measure()
	}
}

let queue = PriorityQueue(.Entry(100, "a"))
queue.add(.Entry(120, "b"))
queue.add(.Entry(140, "c"))

queue.highestPriorityEntry

queue.add(.Entry(80, "d"))
queue.add(.Entry(90, "e"))
queue.highestPriorityEntry

switch queue.tree {
case let .Deep(_, pre, m, suf):
	pre
	m
	suf
default:
	()
}

//queue.pull()
queue.highestPriorityEntry
