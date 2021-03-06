//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Prelude

// MARK: - Node

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

// MARK: - Node : Functor

extension Node {
	
	func map<V1, A1: Measurable where V1 == A1.MeasuredValue>(f: A -> A1) -> Node<V1, A1> {
		switch self {
		case let .Node2(_, a, b):
			return Node<V1, A1>.node2(f(a), f(b))
			
		case let .Node3(_, a, b, c):
			return Node<V1, A1>.node3(f(a), f(b), f(c))
		}
	}
	
	func unsafeMap<A1: Measurable where V == A1.MeasuredValue>(f: A -> A1) -> Node<V, A1> {
		switch self {
		case let .Node2(v, a, b):
			return Node<V, A1>.Node2(v, f(a), f(b))
		case let .Node3(v, a, b, c):
			return Node<V, A1>.Node3(v, f(a), f(b), f(c))
		}
	}
}

// MARK: - Node _ Transformation

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

// MARK: - Node : Foldable

public extension Node {
	public func foldr<B>(initial: B, _ f: A -> B -> B) -> B {
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

// MARK: - Node : Measurable

public extension Node {
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
