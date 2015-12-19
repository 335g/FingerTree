//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Split<T, A> {
	case Split(T, A, T)
}

public func splitDigit<V: Monoid, A: MeasuredType where V == A.MeasuredValue>(predicate: V -> Bool) -> V -> Digit<A> -> Split<Digit<A>?, A> {
	return { i in
		{ digit in
			switch digit {
			case let .One(a):
				return .Split(nil, a, nil)
				
			case let .Two(a, b):
				let va = i.mappend(a.measure())
				if predicate(va) {
					return .Split(nil, a, .One(b))
				}else {
					return .Split(.One(a), b, nil)
				}
				
			case let .Three(a, b, c):
				let va = i.mappend(a.measure())
				let vab = va.mappend(b.measure())
				
				if predicate(va) {
					return .Split(nil, a, .Two(b, c))
				}else if predicate(vab) {
					return .Split(.One(a), b, .One(c))
				}else {
					return .Split(.Two(a, b), c, nil)
				}
				
			case let .Four(a, b, c, d):
				let va = i.mappend(a.measure())
				let vab = va.mappend(b.measure())
				let vabc = vab.mappend(c.measure())
				
				if predicate(va) {
					return .Split(nil, a, .Three(b, c, d))
				}else if predicate(vab) {
					return .Split(.One(a), b, .Two(c, d))
				}else if predicate(vabc) {
					return .Split(.Two(a, b), c, .One(d))
				}else {
					return .Split(.Three(a, b, c), d, nil)
				}
			}
		}
	}
}

public func splitNode<V, A>(predicate: V -> Bool) -> V -> Node<V, A> -> Split<Digit<A>?, A> {
	return { i in
		{ node in
			switch node {
			case let .Node2(_, a, b):
				if predicate(i.mappend(a.measure())) {
					return .Split(nil, a, .One(b))
				}else {
					return .Split(.One(a), b, nil)
				}
				
			case let .Node3(_, a, b, c):
				let va = i.mappend(a.measure())
				let vab = va.mappend(b.measure())
				
				if predicate(va) {
					return .Split(nil, a, .Two(b, c))
				}else if predicate(vab) {
					return .Split(.One(a), b, .One(c))
				}else {
					return .Split(.Two(a, b), c, nil)
				}
			}
		}
	}
}