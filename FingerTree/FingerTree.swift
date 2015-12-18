//  Copyright © 2015 Yoshiki Kudo. All rights reserved.





protocol Semigroup {
	func op(other: Self) -> Self
}

infix operator <> {
	associativity right
	precedence 160
}

func <> <S: Semigroup>(lhs: S, rhs: S) -> S {
	return lhs.op(rhs)
}

func sconcat <S: Semigroup>(initial: S, t: [S]) -> S {
	return t.reduce(initial){ $0 <> $1 }
}

protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

