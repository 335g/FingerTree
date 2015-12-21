//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol NodeType {
	typealias Annotation: Measurable
	typealias Value: Monoid = Annotation.MeasuredValue
}

public enum Node<V: Monoid, A: Measurable where V == A.MeasuredValue>: NodeType {
	public typealias Value = V
	public typealias Annotation = A
	
	case Node2(V, A, A)
	case Node3(V, A, A, A)
	
	// MARK: - static
	
	public static func node2(a: A, _ b: A) -> Node {
		return .Node2(a.measure().mappend(b.measure()), a, b)
	}
	
	public static func node3(a: A, _ b: A, _ c: A) -> Node {
		return .Node3(a.measure().mappend(b.measure().mappend(c.measure())), a, b, c)
	}
	
	// MARK: - map
	
	public func map<V1: Monoid, A1: Measurable where V1 == A1.MeasuredValue>(f: A -> A1) -> Node<V1, A1> {
		switch self {
		case let .Node2(_, a, b):
			return Node<V1, A1>.node2(f(a), f(b))
			
		case let .Node3(_, a, b, c):
			return Node<V1, A1>.node3(f(a), f(b), f(c))
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
	
	public func foldMap<M: Monoid>(f: A -> M) -> M {
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

// MARK: Equatable

public func == <V: Equatable, A: Equatable>(lhs: Node<V, A>, rhs: Node<V, A>) -> Bool {
	switch (lhs, rhs) {
	case let (.Node2(lv, la1, la2), .Node2(rv, ra1, ra2)):
		return lv == rv && la1 == ra1 && la2 == ra2
		
	case let (.Node3(lv, la1, la2, la3), .Node3(rv, ra1, ra2, ra3)):
		return lv == rv && la1 == ra1 && la2 == ra2 && la3 == ra3
		
	default:
		return false
	}
}