//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol Semigroup {
	func mappend(other: Self) -> Self
}

//infix operator <> {
//	associativity right
//	precedence 160
//}
//
//func <> <S: Semigroup>(lhs: S, rhs: S) -> S {
//	return lhs.mappend(rhs)
//}

public func sconcat <S: Semigroup>(initial: S, t: [S]) -> S {
	return t.reduce(initial){ $0.mappend($1) }
}

public protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

public protocol Foldable {
	typealias T
	func foldMap<M: Monoid>(f: T -> M) -> M
}