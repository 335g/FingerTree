//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Digit<T> {
	case One(T)
	case Two(T, T)
	case Three(T, T, T)
	case Four(T, T, T, T)
}

extension Digit where T: Monoid {
	func foldMap<U: Monoid>(f: T -> U) -> U {
		switch self {
		case let .One(a):
			return f(a)
			
		case let .Two(a, b):
			return f(a).mappend(f(b))
			
		case let .Three(a, b, c):
			return f(a).mappend(f(b).mappend(f(c)))
			
		case let .Four(a, b, c, d):
			return f(a).mappend(f(b).mappend(f(c).mappend(f(d))))
		}
	}
}