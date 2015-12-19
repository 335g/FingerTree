//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum FingerTree<V: Monoid, A: MeasuredType where V == A.MeasuredValue> {
	
	case Empty
	case Single(A)
	indirect case Deep(V, Digit<A>, FingerTree<V, Node<V, A>>, Digit<A>)
	
	public static func empty() -> FingerTree {
		return Empty
	}
	
	public static func single(a: A) -> FingerTree {
		return Single(a)
	}
	
	public static func deep(prefix: Digit<A>, deeper: FingerTree<V, Node<V, A>>, suffix: Digit<A>) -> FingerTree {
		
		return .Deep(deeper.mappendVal(prefix.measure()), prefix, deeper, suffix)
	}
	
	public func map<V1: Monoid, A1: MeasuredType where V1 == A1.MeasuredValue>(f: A -> A1) -> FingerTree<V1, A1> {
		switch self {
		case .Empty:
			return .Empty
			
		case let .Single(a):
			return FingerTree<V1, A1>.single(f(a))
			
		case let .Deep(_, prefix, deeper, suffix):
			return FingerTree<V1, A1>.deep(prefix.map(f),
				deeper: deeper.map({ $0.map(f) }),
				suffix: suffix.map(f))
		}
	}
	
	func mappendVal(v: V) -> V {
		switch self {
		case .Empty:
			return v
			
		default:
			return v.mappend(self.measure())
		}
	}
}

// MARK: - Foldable

extension FingerTree: Foldable {
	public func foldMap<M: Monoid>(f: A -> M) -> M {
		switch self {
		case .Empty:
			return M.mempty
			
		case let .Single(x):
			return f(x)
			
		case let .Deep(_, pre, deeper, suf):
			return pre.foldMap(f).mappend(deeper.foldMap({ $0.foldMap(f) }).mappend(suf.foldMap(f)))
		}
	}
}

// MARK: - MeasuredType

extension FingerTree: MeasuredType {
	public typealias MeasuredValue = V
	
	public func measure() -> MeasuredValue {
		switch self {
		case .Empty:
			return V.mempty
			
		case let .Single(a):
			return a.measure()
			
		case let .Deep(v, _, _, _):
			return v
			
		}
	}
}