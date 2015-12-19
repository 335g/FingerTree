//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

infix operator |> {
	associativity left
	precedence 95
}

infix operator <| {
	associativity right
	precedence 95
}

public func |> <V, A> (tree: FingerTree<V, A>, value: A) -> FingerTree<V, A> {
	switch tree {
	case .Empty:
		return FingerTree<V, A>.single(value)
		
	case let .Single(a):
		return FingerTree<V, A>.deep(.One(a), deeper: .Empty, suffix: .One(value))
		
	case let .Deep(v, prefix, deeper, suffix):
		switch suffix {
		case let .One(a):
			return .Deep(v.mappend(value.measure()), prefix, deeper, .Two(a, value))
			
		case let .Two(a, b):
			return .Deep(v.mappend(value.measure()), prefix, deeper, .Three(a, b, value))
			
		case let .Three(a, b, c):
			return .Deep(v.mappend(value.measure()), prefix, deeper, .Four(a, b, c, value))
			
		case let .Four(a, b, c, d):
			return .Deep(v.mappend(value.measure()), prefix, deeper |> Node.node3(a, b, c), .Two(d, value))
		}
	}
}