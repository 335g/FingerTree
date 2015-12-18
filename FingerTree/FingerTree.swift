//  Copyright © 2015 Yoshiki Kudo. All rights reserved.


public enum FingerTree<Value, Annotation> {
	public typealias V = Value
	public typealias A = Annotation
	
	case Empty
	case Single(A)
	indirect case Deep(Digit<A>, FingerTree<V, Node<V, A>>, Digit<A>)
	
	public static func empty() -> FingerTree {
		return Empty
	}
	
	public static func single(a: A) -> FingerTree {
		return Single(a)
	}
	
	public static func deep(prefix: Digit<A>, deeper: FingerTree<V, Node<V, A>>, postfix: Digit<A>) -> FingerTree {
		return Deep(prefix, deeper, postfix)
	}
}


