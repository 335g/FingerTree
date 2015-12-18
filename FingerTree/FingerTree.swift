//  Copyright © 2015 Yoshiki Kudo. All rights reserved.


public enum FingerTree<T, U> {
	
	case Empty
	case Single(U)
	indirect case Deep(Digit<U>, FingerTree<T, Node<T, U>>, Digit<U>)
	
	public static func empty() -> FingerTree {
		return Empty
	}
	
	public static func single(value: U) -> FingerTree {
		return Single(value)
	}
	
	public static func deep(lhs: Digit<U>, fingerTree: FingerTree<T, Node<T, U>>, rhs: Digit<U>) -> FingerTree {
		return Deep(lhs, fingerTree, rhs)
	}
}


public enum Digit<T> {
	case One(T)
	case Two(T, T)
	case Three(T, T, T)
	case Four(T, T, T, T)
}

public enum Node<T, U> {
	case Node2(T, U, U)
	case Node3(T, U, U, U)
}



