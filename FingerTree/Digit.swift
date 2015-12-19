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
	
	// MARK: - split
	
	public func splitDigit<V: Monoid, A: MeasuredType where V == A.MeasuredValue>(predicate: V -> Bool) -> V -> Digit<A> -> Split<Digit<A>?, A> {
		return { i in
			{ digit in
				switch digit {
				case let .One(a):
					return .Split(nil, a, nil)

				case let .Two(a, b):
					let va = i.mappend(a.measure())
					if predicate(va) {
						return .Split(nil, a, .One(b))
					}else {
						return .Split(.One(a), b, nil)
					}
					
				case let .Three(a, b, c):
					let va = i.mappend(a.measure())
					let vab = va.mappend(b.measure())
					
					if predicate(va) {
						return .Split(nil, a, .Two(b, c))
					}else if predicate(vab) {
						return .Split(.One(a), b, .One(c))
					}else {
						return .Split(.Two(a, b), c, nil)
					}
					
				case let .Four(a, b, c, d):
					let va = i.mappend(a.measure())
					let vab = va.mappend(b.measure())
					let vabc = vab.mappend(c.measure())
					
					if predicate(va) {
						return .Split(nil, a, .Three(b, c, d))
					}else if predicate(vab) {
						return .Split(.One(a), b, .Two(c, d))
					}else if predicate(vabc) {
						return .Split(.Two(a, b), c, .One(d))
					}else {
						return .Split(.Three(a, b, c), d, nil)
					}
				}
			}
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