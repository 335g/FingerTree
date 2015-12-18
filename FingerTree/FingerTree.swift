//  Copyright © 2015 Yoshiki Kudo. All rights reserved.



enum Digit<T> {
	case One(T)
	case Two(T, T)
	case Three(T, T, T)
	case Four(T, T, T, T)
}

enum Node<T, U> {
	case Node2(T, U, U)
	case Node3(T, U, U, U)
}

protocol Semigroup {
	func mappend(other: Self) -> Self
}

infix operator <> {
	associativity right
	precedence 160
}

func <> <S: Semigroup>(lhs: S, rhs: S) -> S {
	return lhs.mappend(rhs)
}

func sconcat <S: Semigroup>(initial: S, t: [S]) -> S {
	return t.reduce(initial){ $0 <> $1 }
}

protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

