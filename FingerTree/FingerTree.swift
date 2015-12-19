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
	
	public static func deep(value: V, prefix: Digit<A>, deeper: FingerTree<V, Node<V, A>>, suffix: Digit<A>) -> FingerTree {
		return Deep(value, prefix, deeper, suffix)
	}
}

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