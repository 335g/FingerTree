//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Prelude

public enum Node<V: Monoid, U> {
	case Node2(V, U, U)
	case Node3(V, U, U, U)
}

extension Node: Foldable {
	public func foldMap<M: Monoid>(f: U -> M) -> M {
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