//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Node<T, U> {
	case Node2(T, U, U)
	case Node3(T, U, U, U)
}

extension Node {
	public func foldMap<V: Monoid>(f: U -> V) -> V {
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