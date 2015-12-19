//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Digit<A: MeasuredType> {
	case One(A)
	case Two(A, A)
	case Three(A, A, A)
	case Four(A, A, A, A)
	
	// MARK: - map
	
	public func map<B>(f: A -> B) -> Digit<B> {
		switch self {
		case let .One(a):
			return .One(f(a))
			
		case let .Two(a, b):
			return .Two(f(a), f(b))
			
		case let .Three(a, b, c):
			return .Three(f(a), f(b), f(c))
			
		case let .Four(a, b, c, d):
			return .Four(f(a), f(b), f(c), f(d))
		}
	}
}

// MARK: - Foldable

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

// MARK: - MeasuredType

extension Digit: MeasuredType {
	public typealias MeasuredValue = A.MeasuredValue
	
	public func measure() -> MeasuredValue {
		return foldMap({ $0.measure() })
	}
}