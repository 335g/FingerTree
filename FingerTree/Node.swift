//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Node<V: Monoid, A: MeasuredType where V == A.MeasuredValue> {
	case Node2(V, A, A)
	case Node3(V, A, A, A)
	
	public static func node2(a: A, b: A) -> Node<V, A> {
		return .Node2(a.measure().mappend(b.measure()), a, b)
	}
	
	public static func node3(a: A, b: A, c: A) -> Node<V, A> {
		return .Node3(a.measure().mappend(b.measure().mappend(c.measure())), a, b, c)
	}
}

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

public func nodeToDigit<V, A>(node: Node<V, A>) -> Digit<A> {
	switch node {
	case let .Node2(_, a, b):
		return .Two(a, b)
		
	case let .Node3(_, a, b, c):
		return .Three(a, b, c)
	}
}

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