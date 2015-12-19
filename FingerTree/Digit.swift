//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Prelude

public enum Digit<A: MeasuredType> {
	case One(A)
	case Two(A, A)
	case Three(A, A, A)
	case Four(A, A, A, A)
}

extension Digit: Foldable {
	public func foldMap<M: Monoid>(f: A -> M) -> M {
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

extension Digit: MeasuredType {
	public typealias MeasuredValue = A.MeasuredValue
	
	public func measure() -> MeasuredValue {
		return foldMap({ $0.measure() })
	}
}