//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - __ Node __

public enum Node<V, A: Measurable where V == A.MeasuredValue>: NodeType {
	public typealias Value = V
	public typealias Annotation = A
	
	case Node2(V, A, A)
	case Node3(V, A, A, A)
	
	// MARK: static
	
	static func node2(a: A, _ b: A) -> Node {
		return .Node2(a.measure().mappend(b.measure()), a, b)
	}
	
	static func node3(a: A, _ b: A, _ c: A) -> Node {
		return .Node3(a.measure().mappend(b.measure().mappend(c.measure())), a, b, c)
	}
}

// MARK: - Map

extension Node {
	
	func map<V1, A1: Measurable where V1 == A1.MeasuredValue>(f: A -> A1) -> Node<V1, A1> {
		switch self {
		case let .Node2(_, a, b):
			return Node<V1, A1>.node2(f(a), f(b))
			
		case let .Node3(_, a, b, c):
			return Node<V1, A1>.node3(f(a), f(b), f(c))
		}
	}
}

// MARK: - Transformation

extension Node {
	
	var digit: Digit<A> {
		switch self {
		case let .Node2(_, a, b):
			return .Two(a, b)
			
		case let .Node3(_, a, b, c):
			return .Three(a, b, c)
		}
	}
	
	func reverse<V1, A1: Measurable where V1 == A1.MeasuredValue>(f: A -> A1) -> Node<V1, A1> {
		switch self {
		case let .Node2(_, a, b):
			return Node<V1, A1>.node2(f(b), f(a))
			
		case let .Node3(_, a, b, c):
			return Node<V1, A1>.node3(f(c), f(b), f(a))
		}
	}
}

// MARK: - Foldable

extension Node: Foldable {
	func foldr<B>(initial: B, _ f: A -> B -> B) -> B {
		switch self {
		case let .Node2(_, a, b):
			return f(a)(f(b)(initial))
			
		case let .Node3(_, a, b, c):
			return f(a)(f(b)(f(c)(initial)))
		}
	}
	
	func foldl<B>(initial: B, _ f: B -> A -> B) -> B {
		switch self {
		case let .Node2(_, a, b):
			return f(f(initial)(a))(b)
			
		case let .Node3(_, a, b, c):
			return f(f(f(initial)(a))(b))(c)
		}
	}
	
	func foldMap<M: Monoid>(f: A -> M) -> M {
		return foldl(M.mempty){ m in
			{ m.mappend(f($0)) }
		}
	}
}

// MARK: - Measurable

extension Node: Measurable {
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

// MARK: - Equatable

func == <V: Equatable, A: Equatable>(lhs: Node<V, A>, rhs: Node<V, A>) -> Bool {
	switch (lhs, rhs) {
	case let (.Node2(v1, a1, b1), .Node2(v2, a2, b2)):
		return v1 == v2 && a1 == a2 && b1 == b2
	case let (.Node3(v1, a1, b1, c1), .Node3(v2, a2, b2, c2)):
		return v1 == v2 && a1 == a2 && b1 == b2 && c1 == c2
	default:
		return false
	}
}