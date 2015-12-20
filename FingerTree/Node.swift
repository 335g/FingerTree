//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Node<V: Monoid, A: MeasuredType where V == A.MeasuredValue> {
	
	case Node2(V, A, A)
	case Node3(V, A, A, A)
	
	// MARK: - map
	
	public func map<V1: Monoid, A1: MeasuredType where V1 == A1.MeasuredValue>(f: A -> A1) -> Node<V1, A1> {
		switch self {
		case let .Node2(_, a, b):
			return node2(f(a), f(b))
			
		case let .Node3(_, a, b, c):
			return node3(f(a), f(b), f(c))
		}
	}
}

// MARK: - Foldable

extension Node: Foldable {
	public func foldMap<M: Monoid>(f: A -> M) -> M {
		switch self {
		case let .Node2(_, a, b):
			return f(a).mappend(f(b))
			
		case let .Node3(_, a, b, c):
			return f(a).mappend(f(b).mappend(f(c)))
		}
	}
}

// MARK: - MeasuredType

extension Node: MeasuredType {
	public typealias MeasuredValue = V
	
	public func measure() -> MeasuredValue {
		switch self {
		case let .Node2(v, _, _):
			return v
			
		case let .Node3(v, _, _, _):
			return v
		}
	}
}

// MARK: - Other

public func node2<V: Monoid, A: MeasuredType where V == A.MeasuredValue>(a: A, _ b: A) -> Node<V, A> {
	return .Node2(a.measure().mappend(b.measure()), a, b)
}

public func node3<V: Monoid, A: MeasuredType where V == A.MeasuredValue>(a: A, _ b: A, _ c: A) -> Node<V, A> {
	return .Node3(a.measure().mappend(b.measure().mappend(c.measure())), a, b, c)
}