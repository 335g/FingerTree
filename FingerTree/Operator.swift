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

public func <| <V, A> (value: A, tree: FingerTree<V, A>) -> FingerTree<V, A> {
	switch tree {
	case .Empty:
		return FingerTree<V, A>.single(value)
		
	case let .Single(a):
		return FingerTree<V, A>.deep(.One(a), deeper: .Empty, suffix: .One(value))

	case let .Deep(v, prefix, deeper, suffix):
		switch prefix {
		case let .One(a):
			return .Deep(value.measure().mappend(v), .Two(value, a), deeper, suffix)
			
		case let .Two(a, b):
			return .Deep(value.measure().mappend(v), .Three(value, a, b), deeper, suffix)
			
		case let .Three(a, b, c):
			return .Deep(value.measure().mappend(v), .Four(value, a, b, c), deeper, suffix)
			
		case let .Four(a, b, c, d):
			return .Deep(value.measure().mappend(v), .Two(value, a), Node.node3(b, c, d) <| deeper, suffix)
		}
	}
}