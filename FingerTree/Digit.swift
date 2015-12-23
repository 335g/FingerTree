//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - __ Digit __

public enum Digit<A: Measurable> {
	case One(A)
	case Two(A, A)
	case Three(A, A, A)
	case Four(A, A, A, A)
}

// MARK: - Map

extension Digit {
	
	func map<B>(f: A -> B) -> Digit<B> {
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

// MARK: - Transformation

extension Digit {
	typealias V = A.MeasuredValue
	
	var leftHead: A {
		switch self {
		case let .One(a):
			return a
		case let .Two(a, _):
			return a
		case let .Three(a, _, _):
			return a
		case let .Four(a, _, _, _):
			return a
		}
	}
	
	var rightHead: A {
		switch self {
		case let .One(a):
			return a
		case let .Two(_, a):
			return a
		case let .Three(_, _, a):
			return a
		case let .Four(_, _, _, a):
			return a
		}
	}
	
	var leftTail: Digit? {
		switch self {
		case .One(_):
			return nil
		case let .Two(_, b):
			return .One(b)
		case let .Three(_, b, c):
			return .Two(b, c)
		case let .Four(_, b, c, d):
			return .Three(b, c, d)
		}
	}
	
	var rightTail: Digit? {
		switch self {
		case .One(_):
			return nil
		case let .Two(a, _):
			return .One(a)
		case let .Three(a, b, _):
			return .Two(a, b)
		case let .Four(a, b, c, _):
			return .Three(a, b, c)
		}
	}
	
	var tree: FingerTree<V, A> {
		switch self {
		case let .One(a):
			return .Single(a)
		case let .Two(a, b):
			return FingerTree.deep(prefix: .One(a), deeper: .Empty, suffix: .One(b))
		case let .Three(a, b, c):
			return FingerTree.deep(prefix: .Two(a, b), deeper: .Empty, suffix: .One(c))
		case let .Four(a, b, c, d):
			return FingerTree.deep(prefix: .Two(a, b), deeper: .Empty, suffix: .Two(c, d))
		}
	}
	
	func cons(x: A) -> Digit {
		switch self {
		case let .One(a):
			return .Two(x, a)
		case let .Two(a, b):
			return .Three(x, a, b)
		case let .Three(a, b, c):
			return .Four(x, a, b, c)
		case .Four(_, _, _, _):
			// TODO: throw or optional
			fatalError()
		}
	}
	
	func snoc(x: A) -> Digit {
		switch self {
		case let .One(a):
			return .Two(a, x)
		case let .Two(a, b):
			return .Three(a, b, x)
		case let .Three(a, b, c):
			return .Four(a, b, c, x)
		case .Four(_, _, _, _):
			// TODO: throw or optional
			fatalError()
		}
	}
	
	func reverse<B>(f: A -> B) -> Digit<B> {
		switch self {
		case let .One(a):
			return .One(f(a))
		case let .Two(a, b):
			return .Two(f(b), f(a))
		case let .Three(a, b, c):
			return .Three(f(c), f(b), f(a))
		case let .Four(a, b, c, d):
			return .Four(f(d), f(c), f(b), f(a))
		}
	}
}

// MARK: - Foldable

extension Digit: Foldable {
	
	func foldr<B>(initial: B, _ f: A -> B -> B) -> B {
		switch self {
		case let .One(a):
			return f(a)(initial)
			
		case let .Two(a, b):
			return f(a)(f(b)(initial))
			
		case let .Three(a, b, c):
			return f(a)(f(b)(f(c)(initial)))
			
		case let .Four(a, b, c, d):
			return f(a)(f(b)(f(c)(f(d)(initial))))
		}
	}
	
	func foldl<B>(initial: B, _ f: B -> A -> B) -> B {
		switch self {
		case let .One(a):
			return f(initial)(a)
			
		case let .Two(a, b):
			return f(f(initial)(a))(b)
			
		case let .Three(a, b, c):
			return f(f(f(initial)(a))(b))(c)
			
		case let .Four(a, b, c, d):
			return f(f(f(f(initial)(a))(b))(c))(d)
		}
	}
	
	func foldMap<M : Monoid>(f: A -> M) -> M {
		return foldl(M.mempty){ m in
			{ m.mappend(f($0)) }
		}
	}
}

// MARK: - Measurable

extension Digit: Measurable {
	public typealias MeasuredValue = A.MeasuredValue
	
	public func measure() -> MeasuredValue {
		return foldMap({ $0.measure() })
	}
}


